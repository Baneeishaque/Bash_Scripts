#!/bin/bash

installBrewFormula() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/addToBashConfigurationHelper.bash"
    source "$SCRIPT_DIR/cleanupHomebrew.bash"

    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    local use_cask=${2:-false}
    local create_link=${3:-false}
    local install_cmd="/home/linuxbrew/.linuxbrew/bin/brew install"

    if [ "$use_cask" = "true" ]; then
        install_cmd="/home/linuxbrew/.linuxbrew/bin/brew install --cask"
    fi

    echo "Updating Homebrew..."
    if ! "$SCRIPT_DIR/updateHomebrew.bash"; then
        echo "Error: Homebrew update failed."
        return 1
    fi

    echo "Installing formula $1... (cask: $use_cask)"
    if ! $install_cmd "$1"; then
        echo "Error: Formula installation failed."
        return 1
    fi

    if [ "$create_link" = "true" ]; then
        echo "Creating symbolic link for $1..."
        if [ -e "/usr/local/bin/$1" ]; then
            echo "File already exists at /usr/local/bin/$1. Skipping link creation."
        else
            sudo ln -s "/home/linuxbrew/.linuxbrew/bin/$1" "/usr/local/bin/$1"
            if [ $? -ne 0 ]; then
                echo "Warning: Failed to create symbolic link for $1." >&2
            else
                echo "Symbolic link for $1 created successfully."
            fi
        fi
    fi

    echo "Cleaning up Homebrew..."
    if ! cleanup_homebrew; then
        echo "Error: Homebrew cleanup failed."
        return 1
    fi

    echo "Formula $1 installed successfully."
    return 0
}

installBrewFormulaAfterSystemAppRemoval() {

    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    local use_cask=${2:-false}
    local systemAppPath=$(which $1)
    if [ -n "$systemAppPath" ]; then
        if [ -f "$systemAppPath" ]; then
            echo "Found existing $1 at $systemAppPath. Renaming it for backup."
            sudo mv "$systemAppPath" "$systemAppPath.bak"
            if [ $? -ne 0 ]; then
                echo "Error: Failed to rename $systemAppPath for backup."
                return 1
            fi
        else
            echo "Error: $systemAppPath is not a file."
            return 1
        fi
    else
        echo "No existing $1 found. Proceeding with installation."
    fi
    installBrewFormula "$1" "$use_cask"
}

installBrewFormulaWithBashConfigurations() {

    if [ -z "$1" ]; then
        echo "Error: No formula name provided."
        return 1
    fi

    if [ -z "$2" ]; then
        echo "Error: No configuration to add."
        return 1
    fi

    local use_cask=${3:-false}
    local create_link=${4:-false}

    if installBrewFormula "$1" "$use_cask" "$create_link"; then
        addToBashConfiguration "$2"
    else
        echo "Installation of $1 failed. Skipping configuration update."
        return 1
    fi
}
