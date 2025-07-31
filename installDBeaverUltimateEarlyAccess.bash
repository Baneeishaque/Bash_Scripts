#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/brewFormulaInstallHelper.bash"
source "$SCRIPT_DIR/remoteDebInstallHelper.bash"

. "$SCRIPT_DIR/installPup.bash"

dBeaverDownloadPageUrl="https://dbeaver.com/files/ea/ultimate"
installRemoteDeb $(echo $dBeaverDownloadPageUrl/$(wget -O - $dBeaverDownloadPageUrl | pup 'table.s3_listing_files tbody tr td a attr{href}' | grep '.deb'))
