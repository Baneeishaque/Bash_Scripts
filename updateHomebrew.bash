#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ensure_homebrew.bash"
ensure_homebrew

echo "Updating Homebrew..."
if ! brew update; then
    echo "Error: Homebrew update failed."
    exit 1
fi

echo "Homebrew updated successfully."
exit 0
