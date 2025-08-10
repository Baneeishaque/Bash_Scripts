#!/bin/bash

# Clears the apt package cache to free up disk space.

clear_apt_cache() {
    echo "Cleaning apt cache..."
    if sudo apt clean; then
        echo "Apt cache cleared successfully."
        if sudo rm -rf /workspace/apt-cache/partial/; then
            echo "Partial apt cache removed successfully."
        else
            echo "Error: Failed to remove partial apt cache."
            return 1
        fi
    else
        echo "Error: Failed to clear apt cache."
        return 1
    fi

    echo "Removing obsolete apt lists..."
    # This saves more space, but requires `apt update` before the next install.
    sudo rm -rf /var/lib/apt/lists/*
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clear_apt_cache
fi
