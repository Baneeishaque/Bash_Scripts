#!/bin/bash

# Check if repository path is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <git_repository_path>"
    exit 1
fi

REPO_PATH="$1"
CURRENT_DIR=$(pwd)

# Function to check if a command succeeded
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Function to check if a directory exists and is accessible
check_directory() {
    if [ ! -d "$1" ]; then
        echo "Error: Directory $1 does not exist"
        exit 1
    fi
    
    if [ ! -r "$1" ] || [ ! -w "$1" ]; then
        echo "Error: Directory $1 is not readable or writable"
        exit 1
    fi
}

# Function to check if directory is a git repository
check_git_repo() {
    if [ ! -d "$1/.git" ]; then
        echo "Error: $1 is not a git repository"
        exit 1
    fi
}

# Function to check remote configuration
check_remote() {
    if ! git -C "$1" remote get-url origin >/dev/null 2>&1; then
        echo "Error: No remote 'origin' configured"
        exit 1
    fi
}

# Function to check for unpushed commits
check_unpushed_commits() {
    if [ -n "$(git -C "$1" log origin/$(git -C "$1" rev-parse --abbrev-ref HEAD)..HEAD 2>/dev/null)" ]; then
        echo "Error: There are unpushed commits"
        exit 1
    fi
}

# Function to check for local changes
check_local_changes() {
    if [ -n "$(git -C "$1" status --porcelain)" ]; then
        echo "Error: There are local changes"
        exit 1
    fi
}

# Function to check for stashes
check_stashes() {
    if [ -n "$(git -C "$1" stash list)" ]; then
        echo "Error: There are stashed changes"
        exit 1
    fi
}

# Function to check LFS objects
check_lfs_objects() {
    if command -v git-lfs >/dev/null 2>&1; then
        # Check if there are any unpushed LFS objects
        if [ -n "$(git -C "$1" lfs ls-files)" ]; then
            # Check if all LFS objects are in remote
            if ! git -C "$1" lfs fetch --all >/dev/null 2>&1; then
                echo "Error: Failed to fetch all LFS objects"
                exit 1
            fi
        fi
    fi
}

# Function to check tags
check_tags() {
    # Check for local tags
    if [ -n "$(git -C "$1" tag -l)" ]; then
        echo "Error: There are local tags"
        exit 1
    fi
    
    # Check if all tags are pushed
    if ! git -C "$1" push --tags --dry-run >/dev/null 2>&1; then
        echo "Error: Not all tags are pushed to remote"
        exit 1
    fi
}

# Main execution
echo "Checking repository: $REPO_PATH"

# Store the absolute path
REPO_PATH=$(realpath "$REPO_PATH")

# Perform all checks
check_directory "$REPO_PATH"
check_git_repo "$REPO_PATH"
check_remote "$REPO_PATH"
check_unpushed_commits "$REPO_PATH"
check_local_changes "$REPO_PATH"
check_stashes "$REPO_PATH"
check_lfs_objects "$REPO_PATH"
check_tags "$REPO_PATH"

echo "All checks passed. Proceeding with cleanup..."

# Get the remote URL
REMOTE_URL=$(git -C "$REPO_PATH" remote get-url origin)

# Change to parent directory
cd "$(dirname "$REPO_PATH")"
check_error "Failed to change directory"

# Remove the repository
rm -rf "$(basename "$REPO_PATH")"
check_error "Failed to remove repository"

# Clone without LFS objects
GIT_LFS_SKIP_SMUDGE=1 git clone "$REMOTE_URL" "$(basename "$REPO_PATH")"
check_error "Failed to clone repository"

# Return to original directory
cd "$CURRENT_DIR"
check_error "Failed to return to original directory"

echo "Repository cleanup completed successfully" 