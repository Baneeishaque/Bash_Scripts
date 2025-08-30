#!/bin/bash

curl https://rclone.org/install.sh | sudo bash -s beta

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/copyConfigurations.bash"
