#!/bin/bash
    
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../aptInstallHelper.bash"

. "$SCRIPT_DIR/installRcloneBeta.bash"
. "$SCRIPT_DIR/../updatePackageIndex.bash"
aptInstall rclone-browser
