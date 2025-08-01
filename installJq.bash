#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

if ! command -v jq &>/dev/null; then
    installBrewFormula install jq
fi
