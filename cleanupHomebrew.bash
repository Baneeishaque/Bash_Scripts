#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ensure_homebrew.bash"
ensure_homebrew

echo "Running brew autoremove..."
if ! brew autoremove; then
    echo "Error: brew autoremove failed."
    exit 1
fi

echo "Running brew cleanup..."
if ! brew cleanup; then
    echo "Error: brew cleanup failed."
    exit 1
fi
