#!/bin/bash

installRemoteDeb() {

    local downloadUrl
    local installationFile
    local SCRIPT_DIR

    downloadUrl=$1
    installationFile="package.deb"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    wget -O "$installationFile" "$downloadUrl"
    "$SCRIPT_DIR/updatePackageIndex.bash"
    sudo apt install -y "./$installationFile"
    rm "$installationFile"
}
