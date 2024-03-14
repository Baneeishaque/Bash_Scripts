#!/bin/bash

source git_backup_recursive.bash

if [ "$1" == "" ]; then

	updater "" "" "false" "false" "true"

else

	for dir in "$@"; do
	
		updater "$dir" "" "false" "false" "true"
	done
fi
