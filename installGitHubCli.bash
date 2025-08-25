#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.bash"

if is_installed "$TOOL_GH"; then
    echo "GitHub CLI ($TOOL_GH) is already installed."
    exit 0
fi

# shellcheck source=aptInstallHelper.bash
source "$SCRIPT_DIR/$SCRIPT_APT_INSTALL_HELPER"
dispatch_install_msg "$TOOL_GH"

require_curl
require_sudo
require_dd
require_chmod
require_tee

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
bash "$SCRIPT_DIR/$SCRIPT_UPDATE_PACKAGE_INDEX"

aptInstall "$TOOL_GH" "true"
