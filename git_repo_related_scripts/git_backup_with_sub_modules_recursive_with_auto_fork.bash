#!/bin/bash

# Get the directory of the current script
DIR="$(dirname "$0")"

# Source the git_backup_recursive.bash script from the same directory
source "$DIR/git_backup_recursive.bash"

if [ "$1" == "" ]; then

	updater "" "fork" "false" "false" "true"

else

	for dir in "$@"; do

		updater "$dir" "fork" "false" "false" "true"
	done
fi
