#!/bin/bash

instsll_act() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

    installBrewFormula act
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    instsll_act
fi
