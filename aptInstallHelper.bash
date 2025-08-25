#!/bin/bash

# Usage: dispatch_install_msg <tool>
dispatch_install_msg() {

    local tool="$1"

    if is_macos; then

        todo_msg "Install $tool on macOS (use brew or manual download)."

    elif is_windows; then

        todo_msg "Install $tool on Windows (use official installer)."

    elif is_linux; then

        if ! is_apt_based; then

            todo_msg "Install $tool on non-apt Linux (use manual download or other package manager)."
        fi
        return 0
    else
        echo "Unsupported OS."
        exit 1
    fi
}

# Function to install packages using apt
# Args:
#   $1: Package name(s) to install (space-separated)
# Returns:
#   0: Installation successful
#   1: Installation failed
aptInstall() {

    local skip_check="${2:-false}"

    if [ -z "$1" ]; then
        echo "Error: No package name(s) provided."
        return 1
    fi

    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/utils.bash"

    if [[ "$skip_check" != "true" ]]; then
        dispatch_install_msg "$1"
    fi

    echo "Updating package index..."
    bash "$SCRIPT_DIR/$SCRIPT_UPDATE_PACKAGE_INDEX"

    require_apt
    echo "Installing package(s): $1"

    # shellcheck disable=SC2086
    if sudo apt install -y $1; then

        echo "Package(s) $1 installed successfully."
        return 0

    else

        echo "Error: Failed to install package(s) $1"
        return 1
    fi
}
