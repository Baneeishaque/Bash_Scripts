#!/bin/bash

cleanup_homebrew() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/installHomeBrew.bash"
    install_homebrew

    echo "Running brew autoremove..."
    if ! brew autoremove; then
        echo "Error: brew autoremove failed."
        return 1
    fi

    echo "Running brew cleanup..."
    if ! brew cleanup; then
        echo "Error: brew cleanup failed."
        return 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    cleanup_homebrew
fi
