#!/bin/bash

source git_backup_recursive.bash

if [ "$1" == "" ]; then
	updater "" "fork" "true" "false"
else
	for dir in "$@"; do
		updater "$dir" "fork" "true" "false"
	done
fi
