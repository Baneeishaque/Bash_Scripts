#!/bin/bash

source git_backup_recursive.bash

if [ "$1" == "" ]; then

	updater "" "github" "true" "false" "false"

else

	for dir in "$@"; do
	
		updater "$dir" "github" "true" "false" "false"
	done
fi
