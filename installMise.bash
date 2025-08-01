#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

installBrewFormulaWithBashConfigurations mise 'eval "$(mise activate bash)"'
