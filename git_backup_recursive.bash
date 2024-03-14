#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

# Function to invoke the git handler
# $1: The directory to handle (string)
function invoke_git_handler() {

	invoke_fork "$1"
}

# Function to invoke the Fork Git client
# $1: The directory to open in Fork (string)
function invoke_fork() {

	Fork.exe "$1"
	# pause 'Press [Enter] key to continue...'
}

# Function to pause the script
# $*: The prompt to display when pausing
function pause(){

   read -p "$*"
}

# Function to update a directory
# $1: The directory to update (string)
# $2: Whether to invoke the git handler (boolean)
function update() {

	local d="$1"
	local want_invoke_handler="$2"

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
				
				# Interaction with Handler
				if [ "$want_invoke_handler" == "true" ]; then
					invoke_git_handler "`pwd`"
				fi

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
				
				# Interaction with Handler
				if [ "$want_invoke_handler" == "true" ]; then
					invoke_git_handler "`pwd`"
				fi

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

# Function to scan directories
# $1: Directories to scan (string)
# $2: Whether to invoke the git handler (boolean)
function scan() {
	
	#echo "`pwd`"
	#echo "About to scan $*"

	local want_invoke_handler="$2"
	
	for x in $1; do
		update "$x" "$want_invoke_handler"
	done
}

# Function to update directories
# $1: The directory to update (string)
# $2: Whether to invoke the git handler (boolean)
function updater() {
	
	local dir="$1"
	local want_invoke_handler="$2"

	if [ "$dir" != "" ]; then cd "$dir" > /dev/null; fi
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
	
	if [ "$want_invoke_handler" == "true" ]; then
		scan * true
	else
		scan *
	fi
}

if [ "$1" == "" ]; then
	updater
else
	for dir in "$@"; do
		updater "$dir"
	done
fi
