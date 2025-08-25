#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.bash"

if is_installed "$TOOL_TREE"; then
    echo "Tree ($TOOL_TREE) is already installed."
    exit 0
fi

# shellcheck source=aptInstallHelper.bash
source "$SCRIPT_DIR/$SCRIPT_APT_INSTALL_HELPER"
aptInstall "$TOOL_TREE"
