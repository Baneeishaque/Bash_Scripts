#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/installHomeBrew.bash"
install_homebrew

echo "Updating Homebrew..."
if ! /home/linuxbrew/.linuxbrew/bin/brew update; then
    echo "Error: Homebrew update failed."
    exit 1
fi

echo "Homebrew updated successfully."
exit 0
