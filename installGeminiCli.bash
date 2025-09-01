#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.bash"

if is_installed "$TOOL_GEMINI_CLI"; then
    echo "Gemini CLI ($TOOL_GEMINI_CLI) is already installed."
else
    source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"
    installBrewFormula gemini-cli
fi
