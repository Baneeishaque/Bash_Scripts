#!/bin/bash

# Default values
DRY_RUN=false
VERBOSE=false
EXIT_CODE=0

# Function to print verbose messages
verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "[VERBOSE] $1"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <git_repository_path> [options]"
    echo "Options:"
    echo "  --dry-run     Show what would be done without making changes"
    echo "  --verbose     Show detailed output"
    echo "  --help        Show this help message"
    return 1
}

# Parse arguments
REPO_PATH=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            show_usage
            EXIT_CODE=$?
            return $EXIT_CODE
            ;;
        *)
            if [ -z "$REPO_PATH" ]; then
                REPO_PATH="$1"
                shift
            else
                echo "Error: Too many arguments"
                show_usage
                EXIT_CODE=$?
                return $EXIT_CODE
            fi
            ;;
    esac
done

# Check if repository path is provided
if [ -z "$REPO_PATH" ]; then
    echo "Error: Repository path is required"
    show_usage
    EXIT_CODE=$?
    return $EXIT_CODE
fi

if [ "$VERBOSE" = true ]; then
    echo "Running in verbose mode"
fi

if [ "$DRY_RUN" = true ]; then
    echo "Running in dry-run mode - no actual changes will be made"
fi

CURRENT_DIR=$(pwd)

# Function to check if a command succeeded
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        return 1
    fi
    return 0
}

# Function to check if a directory exists and is accessible
check_directory() {
    verbose "Checking directory: $1"
    if [ ! -d "$1" ]; then
        echo "Error: Directory $1 does not exist"
        return 1
    fi
    
    if [ ! -r "$1" ] || [ ! -w "$1" ]; then
        echo "Error: Directory $1 is not readable or writable"
        return 1
    fi
    verbose "Directory check passed"
    return 0
}

# Function to check if directory is a git repository
check_git_repo() {
    verbose "Checking if $1 is a git repository"
    if [ "$2" = "submodule" ]; then
        if [ ! -f "$1/.git" ]; then
            echo "Error: $1 is not a submodule git repository"
            return 1
        fi
    else
        if [ ! -d "$1/.git" ]; then
            echo "Error: $1 is not a main git repository"
            return 1
        fi
    fi
    verbose "Git repository check passed"
    return 0
}

# Function to check remote configuration
check_remote() {
    verbose "Checking remote configuration"
    if ! git -C "$1" remote get-url origin >/dev/null 2>&1; then
        echo "Error: No remote 'origin' configured"
        return 1
    fi
    verbose "Remote configuration check passed"
    return 0
}

# Function to check for unpushed commits
check_unpushed_commits() {
    verbose "Checking for unpushed commits"
    if [ -n "$(git -C "$1" log origin/$(git -C "$1" rev-parse --abbrev-ref HEAD)..HEAD 2>/dev/null)" ]; then
        echo "Error: There are unpushed commits"
        return 1
    fi
    verbose "No unpushed commits found"
    return 0
}

# Function to check for local changes
check_local_changes() {
    verbose "Checking for local changes"
    if [ -n "$(git -C "$1" status --porcelain)" ]; then
        echo "Error: There are local changes"
        return 1
    fi
    verbose "No local changes found"
    return 0
}

# Function to check for stashes
check_stashes() {
    verbose "Checking for stashes"
    if [ -n "$(git -C "$1" stash list)" ]; then
        echo "Error: There are stashed changes"
        return 1
    fi
    verbose "No stashes found"
    return 0
}

# Function to check LFS objects
check_lfs_objects() {
    verbose "Checking LFS objects"
    if command -v git-lfs >/dev/null 2>&1; then
        # Check if there are any unpushed LFS objects
        if [ -n "$(git -C "$1" lfs ls-files)" ]; then
            verbose "Found LFS files, checking if all are in remote"
            # Check if all LFS objects are in remote
            if ! git -C "$1" lfs fetch --all >/dev/null 2>&1; then
                echo "Error: Failed to fetch all LFS objects"
                return 1
            fi
            verbose "All LFS objects are in remote"
        else
            verbose "No LFS files found"
        fi
    else
        verbose "git-lfs not installed, skipping LFS check"
    fi
    return 0
}

# Function to check tags
check_tags() {
    verbose "Checking tags"
    # Check for local tags
    if [ -n "$(git -C "$1" tag -l)" ]; then
        echo "Error: There are local tags"
        return 1
    fi
    
    # Check if all tags are pushed
    if ! git -C "$1" push --tags --dry-run >/dev/null 2>&1; then
        echo "Error: Not all tags are pushed to remote"
        return 1
    fi
    verbose "Tags check passed"
    return 0
}

# Function to check submodules
check_submodules() {
    # Check if .gitmodules exists
    if [ -f "$1/.gitmodules" ]; then
        echo "Checking submodules..."
        
        # Initialize submodules if needed
        if ! git -C "$1" submodule status >/dev/null 2>&1; then
            echo "Error: Failed to get submodule status"
            return 1
        fi
        
        # Get list of submodules
        while IFS= read -r submodule; do
            if [ -n "$submodule" ]; then
                submodule_path=$(echo "$submodule" | awk '{print $2}')
                echo "Checking submodule: $submodule_path"
                
                # Change to submodule directory
                cd "$1/$submodule_path" || return 1
                
                # Run checks
                check_directory "$(pwd)" || { cd "$1"; return 1; }
                check_git_repo "$(pwd)" submodule || { cd "$1"; return 1; }
                check_remote "$(pwd)" || { cd "$1"; return 1; }
                check_unpushed_commits "$(pwd)" || { cd "$1"; return 1; }
                check_local_changes "$(pwd)" || { cd "$1"; return 1; }
                check_stashes "$(pwd)" || { cd "$1"; return 1; }
                check_lfs_objects "$(pwd)" || { cd "$1"; return 1; }
                check_tags "$(pwd)" || { cd "$1"; return 1; }
                
                # Return to parent directory
                cd "$1" || return 1
            fi
        done < <(git -C "$1" submodule status)
    fi
    return 0
}

# Main execution
echo "Checking repository: $REPO_PATH"

# Store the absolute path
REPO_PATH=$(realpath "$REPO_PATH")
verbose "Absolute repository path: $REPO_PATH"

# First check submodules
check_submodules "$REPO_PATH"
if [ $? -ne 0 ]; then
    EXIT_CODE=1
    return $EXIT_CODE
fi

# Then perform all other checks
check_directory "$REPO_PATH" || EXIT_CODE=1
check_git_repo "$REPO_PATH" || EXIT_CODE=1
check_remote "$REPO_PATH" || EXIT_CODE=1
check_unpushed_commits "$REPO_PATH" || EXIT_CODE=1
check_local_changes "$REPO_PATH" || EXIT_CODE=1
check_stashes "$REPO_PATH" || EXIT_CODE=1
check_lfs_objects "$REPO_PATH" || EXIT_CODE=1
check_tags "$REPO_PATH" || EXIT_CODE=1

if [ $EXIT_CODE -ne 0 ]; then
    return $EXIT_CODE
fi

echo "All checks passed. Proceeding with cleanup..."

# Get the remote URL
REMOTE_URL=$(git -C "$REPO_PATH" remote get-url origin)
verbose "Remote URL: $REMOTE_URL"

if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would perform the following actions:"
    echo "1. Change directory to: $(dirname "$REPO_PATH")"
    echo "2. Remove repository directory: $(basename "$REPO_PATH")"
    echo "3. Clone repository without LFS objects: $REMOTE_URL"
    echo "4. Initialize submodules without LFS objects (if .gitmodules exists)"
    echo "5. Return to original directory: $CURRENT_DIR"
    echo ""
    echo "Dry run completed. No actual changes were made."
    cd "$CURRENT_DIR"
    return 0
fi

ensure_trash_utility() {
    if command -v trash &>/dev/null; then
        return 0
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: try to install trash via brew if not present
        if ! command -v trash &>/dev/null; then
            echo "Installing 'trash' via Homebrew..."
            if command -v brew &>/dev/null; then
                brew install trash
            else
                echo "Homebrew not found. Please install Homebrew or use 'brew install trash' manually."
                return 1
            fi
        fi
        return 0
    elif [[ "$OSTYPE" == "linux"* ]]; then
        # Linux: check for gio or kioclient5, otherwise suggest install
        if command -v gio &>/dev/null; then
            return 0
        elif command -v kioclient5 &>/dev/null; then
            return 0
        else
            echo "No trash utility found. Please install 'gio' (Gnome), 'kioclient5' (KDE), or 'trash-cli' (pip install trash-cli)."
            return 1
        fi
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win32"* ]]; then
        # Windows: try to install recycle-bin via winget
        if ! command -v recycle-bin &>/dev/null; then
            echo "Installing 'recycle-bin' via winget..."
            if command -v winget &>/dev/null; then
                winget install --id=Recycle.Bin -e
            else
                echo "winget not found. Please install 'recycle-bin' manually."
                return 1
            fi
        fi
        return 0
    fi

    echo "No supported trash utility found for your OS."
    return 1
}

move_to_trash() {
    local target="$1"
    if command -v trash &>/dev/null; then
        trash "$target"
    elif command -v gio &>/dev/null; then
        gio trash "$target"
    elif command -v kioclient5 &>/dev/null; then
        kioclient5 move "$target" trash:/
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e 'tell app "Finder" to delete POSIX file "'"$target"'"'
    elif command -v recycle-bin &>/dev/null; then
        recycle-bin "$target"
    else
        echo "No trash utility found. Aborting for safety."
        return 1
    fi
}

# Ensure trash utility is available
ensure_trash_utility || { echo "No trash utility available. Aborting."; return 1; }

# Change to parent directory
verbose "Changing to parent directory: $(dirname "$REPO_PATH")"
cd "$(dirname "$REPO_PATH")"
check_error "Failed to change directory" || EXIT_CODE=1

# Move to trash instead of rm -rf
verbose "Moving repository directory to Trash: $(basename "$REPO_PATH")"
move_to_trash "$(basename "$REPO_PATH")"
check_error "Failed to move repository to Trash" || EXIT_CODE=1

# Clone without LFS objects and initialize submodules
verbose "Cloning repository without LFS objects"
GIT_LFS_SKIP_SMUDGE=1 git clone "$REMOTE_URL" "$(basename "$REPO_PATH")"
check_error "Failed to clone repository" || EXIT_CODE=1

# Initialize and update submodules without LFS objects
cd "$(basename "$REPO_PATH")"
check_error "Failed to change to repository directory" || EXIT_CODE=1

if [ -f ".gitmodules" ]; then
    verbose "Initializing submodules without LFS objects"
    GIT_LFS_SKIP_SMUDGE=1 git submodule update --init --recursive
    check_error "Failed to initialize submodules" || EXIT_CODE=1
fi

# Return to original directory
verbose "Returning to original directory: $CURRENT_DIR"
cd "$CURRENT_DIR"
check_error "Failed to return to original directory" || EXIT_CODE=1

if [ $EXIT_CODE -eq 0 ]; then
    echo "Repository cleanup completed successfully"
fi

# Only call exit if not being sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ "$sourced" -eq 0 ]; then
    exit $EXIT_CODE
else
    return $EXIT_CODE
fi
