#!/bin/bash

install_homebrew() {

    local SCRIPT_DIR
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/addToBashConfigurationHelper.bash"
    source "$SCRIPT_DIR/aptInstallHelper.bash"
    source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

    if ! command -v /home/linuxbrew/.linuxbrew/bin/brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        local BREW_EVAL_CMD="$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        addToBashConfiguration "eval $BREW_EVAL_CMD"
        source ~/.bashrc
        aptInstall "build-essential procps curl file git"
        installBrewFormula gcc
    else
        echo "Homebrew is already installed."
    fi
}
