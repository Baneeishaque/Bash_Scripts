#!/bin/bash

# Get the directory of the current script
DIR="$(dirname "$0")"

# Source the git_backup_recursive.bash script from the same directory
source "$DIR/git_backup_recursive.bash"

if [ "$1" == "" ]; then

	updater "" "fork" "true" "false" "false"

else

	for dir in "$@"; do

		updater "$dir" "fork" "true" "false" "false"
	done
fi
