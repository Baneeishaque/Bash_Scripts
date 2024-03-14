#!/bin/bash

# Import the updater function from git_backup_recursive.bash
source git_backup_recursive.bash

# Call the updater function with the desired parameters
if [ "$1" == "" ]; then
	updater "" "fork" "false" "true" "false"
else
	for dir in "$@"; do
		updater "$dir" "fork" "fasle" "true" "false"
	done
fi
