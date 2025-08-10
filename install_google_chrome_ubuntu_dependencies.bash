#!/bin/bash

install_google_chrome_ubuntu_dependencies() {

    local SCRIPT_DIR

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/aptInstallHelper.bash"

    aptInstall "libasound2-dev libgtk-3-dev libnss3-dev fonts-noto fonts-noto-cjk"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_google_chrome_ubuntu_dependencies
fi
