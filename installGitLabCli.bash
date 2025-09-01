#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"

installBrewFormula glab

sudo ln -s /home/linuxbrew/.linuxbrew/bin/glab /usr/local/bin/glab
