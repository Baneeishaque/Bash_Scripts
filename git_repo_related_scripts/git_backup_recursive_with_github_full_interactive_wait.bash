#!/bin/bash

# Import the updater function from git_backup_recursive.bash
# Get the directory of the current script
DIR="$(dirname "$0")"

# Source the git_backup_recursive.bash script from the same directory
source "$DIR/git_backup_recursive.bash"

# Call the updater function with the desired parameters
if [ "$1" == "" ]; then
	updater "" "github" "false" "true" "false"
else
	for dir in "$@"; do
		updater "$dir" "github" "fasle" "true" "false"
	done
fi
