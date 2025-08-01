#!/bin/bash

# Function to install packages using apt
# Args:
#   $1: Package name(s) to install (space-separated)
# Returns:
#   0: Installation successful
#   1: Installation failed

aptInstall() {

  local SCRIPT_DIR

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/addToBashConfigurationHelper.bash"

  if [ -z "$1" ]; then
    echo "Error: No package name(s) provided."
    return 1
  fi

  echo "Updating package index..."
  . "$SCRIPT_DIR/updatePackageIndex.bash"

  echo "Installing package(s): $1"
  sudo apt install -y $1

  if [ $? -eq 0 ]; then
    echo "Package(s) $1 installed successfully."
    return 0
  else
    echo "Error: Failed to install package(s) $1"
    return 1
  fi
}