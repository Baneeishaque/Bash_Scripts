#!/bin/bash

install_power_shell() {

    local SCRIPT_DIR
    local VERSION_ID

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/aptInstallHelper.bash"
    
    VERSION_ID=$(sudo grep -oP 'VERSION_ID="\K[^"]+' /etc/os-release)
    wget -q "https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb"
    . "$SCRIPT_DIR/updatePackageIndex.bash"
    aptInstall "./packages-microsoft-prod.deb"
    . "$SCRIPT_DIR/updatePackageIndex.bash"
    aptInstall powershell
    rm packages-microsoft-prod.deb
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_power_shell
fi
