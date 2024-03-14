#!/bin/bash

source ./git_backup_recursive.bash

if [ "$1" == "" ]; then

	updater "" true

else

	for dir in "$@"; do
	
		updater "$dir" true
	done
fi
