#!/bin/bash

ensure_homebrew() {

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/addToBashConfigurationHelper.bash"

    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        BREW_EVAL_CMD="$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        addToBashConfiguration "eval $BREW_EVAL_CMD"
        eval "$BREW_EVAL_CMD"
    fi
}
