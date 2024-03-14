#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

function update() {

	local d="$1"

	if [ -d "$d" ]; then
		
		cd "$d" > /dev/null

		if [ -d ".git" ]; then

			printf "`pwd`\n" >> $CURRENT_DIRECTORY/git_folders.txt
			
			printf "%b\n" "\n${HIGHLIGHT}Processing `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			# TODO : Check for pulll permission
			git fetch --all | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			git pull --all | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			if [[ `git status --porcelain` ]]; then
				
				# Changes
				git status | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				printf "`pwd`\n" >> $CURRENT_DIRECTORY/git_folders_with_changes.txt
			
				# TODO : Check for own repository
				# git ls-remote /url/remote/repo
				# git add . | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				# git commit -m "$now" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				# git push | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				
				# Interaction with Github
				invoke_git_handler "`pwd`"

			# else
			
				# No changes
				
			fi
			
			# git log origin/master..HEAD
			if [[ `git log --branches --not --remotes` ]]; then
				
				# Changes
				git log --branches --not --remotes | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				printf "`pwd`\n" >> $CURRENT_DIRECTORY/git_folders_with_unpushed_commits.txt
			
				# TODO : Check for own repository
				# git ls-remote /url/remote/repo
				# git push | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				
				# Interaction with Github
				invoke_git_handler "`pwd`"

			# else
			
				# No changes
				
			fi
			
		elif [ ! -d .svn ] && [ ! -d CVS ]; then

			printf "%b\n" "\n${HIGHLIGHT}Non Git Folder : `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# echo "Looking for $d/.ignore"| tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# if [ -e "$d/.ignore" ]; then

				# printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# else

				# printf "`pwd`\n" >> $CURRENT_DIRECTORY/non_git_folders.txt
				# github .
				# scan *

			# fi
			
			# TODO : Avoid Android_Studio like place holder folders
			printf "`pwd`\n" >> $CURRENT_DIRECTORY/non_git_folders.txt
			# github .
			scan *
		fi

		cd .. > /dev/nul
	fi
	#echo "Exiting update: pwd=`pwd`"
}

function scan() {
	
	#echo "`pwd`"
	#echo "About to scan $*"
	for x in $*; do
		update "$x"
	done
}

function updater() {
	
	if [ "$1" != "" ]; then cd "$1" > /dev/null; fi
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
	scan *
}

function invoke_git_handler() {

	invoke_fork "$1"
}

function invoke_github() {

	github "$1"
	pause 'Press [Enter] key to continue...'
}

function invoke_fork() {

	Fork.exe "$1"
	pause 'Press [Enter] key to continue...'
}

function pause(){

   read -p "$*"
}

if [ "$1" == "" ]; then

	updater

else

	for dir in "$@"; do
	
		updater "$dir"
	done
fi
