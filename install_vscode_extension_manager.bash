#!/bin/bash

instsll_deno() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

    installBrewFormula vsce
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    instsll_deno
fi
