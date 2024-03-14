#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

# Function to invoke the git handler
# $1: The directory to handle (string)
# $2: The handler to invoke (string)
function invoke_git_handler() {
	local dir="$1"
	local handler="$2"

	if [ "$handler" == "github" ] || [ "$handler" == "both" ]; then
		invoke_github "$dir" true
	fi

	if [ "$handler" == "fork" ] || [ "$handler" == "both" ]; then
		invoke_fork "$dir" true
	fi
}

# Function to invoke the Fork Git client
# $1: The directory to open in Fork (string)
# $2: Whether to pause the script (boolean)
function invoke_fork() {
	local dir="$1"
	local pause="$2"

	Fork.exe "$dir"
	if [ "$pause" == "true" ]; then
		pause 'Press [Enter] key to continue...'
	fi
}

# Function to invoke the Github client
# $1: The directory to open in Github (string)
# $2: Whether to pause the script (boolean)
function invoke_github() {
	local dir="$1"
	local pause="$2"

	github "$dir"
	if [ "$pause" == "true" ]; then
		pause 'Press [Enter] key to continue...'
	fi
}

# Function to pause the script
# $*: The prompt to display when pausing
function pause(){
   read -p "$*"
}

# Function to update a directory
# $1: The directory to update (string)
# $2: Whether to invoke the git handler (boolean)
# $3: The handler to invoke (string)
# $4: Whether to pause the script (boolean)
function update() {
	local d="$1"
	local want_invoke_handler="$2"
	local handler="$3"
	local pause="$4"

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
					invoke_git_handler "`pwd`" "$handler"
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
					invoke_git_handler "`pwd`" "$handler"
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

		cd .. > /dev/null
	fi
	#echo "Exiting update: pwd=`pwd`"
}

# Function to scan directories
# $1: Directories to scan (string)
# $2: The handler to invoke (string)
# $3: Whether to pause the script (boolean)
function scan() {
	
	#echo "`pwd`"
	#echo "About to scan $*"

	local want_invoke_handler="$2"
	local handler="$2"
	local pause="$3"
	
	for x in $1; do
		update "$x" "$want_invoke_handler" "$handler" "$pause"
	done
}

# Function to update directories
# $1: The directory to update (string)
# $2: The handler to invoke (string)
# $3: Whether to pause the script (boolean)
function updater() {
	local dir="$1"
	local handler="$2"
	local pause="$3"

	if [ "$dir" != "" ]; then cd "$dir" > /dev/null; fi
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
	
	if [ "$pause" == "true" ]; then
		scan * "$handler" true
	else
		scan * "$handler"
	fi
}

if [ "$1" == "" ]; then
	updater
else
	for dir in "$@"; do
		updater "$dir"
	done
fi
