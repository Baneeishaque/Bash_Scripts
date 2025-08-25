#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.bash"

# shellcheck source=aptInstallHelper.bash
source "$SCRIPT_DIR/$SCRIPT_APT_INSTALL_HELPER"
dispatch_install_msg "$TOOL_APT"

sudo apt update
