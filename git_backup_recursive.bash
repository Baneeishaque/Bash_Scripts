#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

# Function to invoke the git handler
# $1: The directory to handle (string)
# $2: The handler to invoke (string)
# $3: Whether to pause the script (boolean)
# $4: Whether to wait for the process to finish (boolean)
function invoke_git_handler() {
	local dir="$1"
	local handler="$2"
	local pause="$3"
	local is_full_interactive_wait="$4"

	if [ $handler == "github" ]; then
		invoke_client "github" $dir $pause $is_full_interactive_wait
	elif [ $handler == "fork" ]; then
		invoke_client "fork.exe" $dir $pause $is_full_interactive_wait
	elif [ $handler == "both" ]; then
		invoke_client "github" $dir $pause $is_full_interactive_wait
		invoke_client "fork.exe" $dir $pause $is_full_interactive_wait
	else
		echo "Invalid handler. Please use 'github', 'fork', or 'both'."
		exit 1
	fi
}

# Function to invoke the Git client
# $1: The client to invoke (string)
# $2: The directory to open in the client (string)
# $3: Whether to pause the script (boolean)
# $4: Whether to wait for the process to finish (boolean)
function invoke_client() {
	local client="$1"
	local dir="$2"
	local pause="$3"
	local is_full_interactive_wait="$4"

	$client "$dir"
	if [ $is_full_interactive_wait == "true" ]; then
		wait $!
	elif [ $pause == "true" ]; then
		pause 'Press [Enter] key to continue...'
	fi
}

# Function to pause the script
# $*: The prompt to display when pausing
function pause(){
   read -p "$*"
}

# Function to handle non-git directories
# $1: The directory to handle (string)
function non_git_handler() {
	invoke_github "$1"
}

# Function to update a directory
# $1: The directory to update (string)
# $2: Whether to invoke the git handler (boolean)
# $3: The handler to invoke (string)
# $4: Whether to pause the script (boolean)
# $5: Whether to wait for the process to finish (boolean)
function update() {
	local d="$1"
	local want_invoke_handler="$2"
	local handler="$3"
	local pause="$4"
	local is_full_interactive_wait="$5"

	if [ -d "$d" ]; then
		cd "$d" > /dev/null

		if [ -d ".git" ]; then
			printf "`pwd`\n" >> $CURRENT_DIRECTORY/git_folders.txt
			printf "%b\n" "\n${HIGHLIGHT}Processing `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			# TODO : Check for pull permission
			git fetch --all | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			git pull --all | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			if [ $is_full_interactive_wait == "true" ]; then
				invoke_git_handler "`pwd`" $handler $pause $is_full_interactive_wait
			else
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
					if [ $want_invoke_handler == "true" ]; then
						invoke_git_handler "`pwd`" $handler $pause $is_full_interactive_wait
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
					if [ $want_invoke_handler == "true" ]; then
						invoke_git_handler "`pwd`" $handler $pause $is_full_interactive_wait
					fi
				# else
				
					# No changes
					
				fi
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
			non_git_handler "`pwd`"
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
# $4: Whether to wait for the process to finish (boolean)
function scan() {
	
	#echo "`pwd`"
	#echo "About to scan $*"

	local want_invoke_handler="$2"
	local handler="$3"
	local pause="$4"
	local is_full_interactive_wait="$5"
	
	for x in $1; do
		update $x $want_invoke_handler $handler $pause $is_full_interactive_wait
	done
}

# Function to update directories
# $1: The directory to update (string)
# $2: The handler to invoke (string)
# $3: Whether to pause the script (boolean)
# $4: Whether to wait for the process to finish (boolean)
function updater() {
	local dir="$1"
	local handler="$2"
	local pause="$3"
	local is_full_interactive_wait="$4"

	# If handler is 'github' or 'fork', set want_invoke_handler to true
	local want_invoke_handler=""
	if [ $handler == "github" ] || [ $handler == "fork" ]; then
		$want_invoke_handler="true"
	elif [ "$handler" == "" ]; then
		$want_invoke_handler="false"
	else
		echo "Warning: Handler should be either 'github', 'fork' or empty."
		exit 1
	fi

	if [ $dir != "" ]; then cd $dir > /dev/null; fi
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
	
	scan * $want_invoke_handler $handler $pause $is_full_interactive_wait
}


if [ "$1" == "" ]; then
	updater "" "" "false" "false"
else
	for dir in "$@"; do
		updater $dir "" "false" "false"
	done
fi
