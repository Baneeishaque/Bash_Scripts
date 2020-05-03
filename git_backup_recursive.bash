#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

function update {
  local d="$1"
  if [ -d "$d" ]; then
    #echo "Looking for $d/.ignore"
    if [ -e "$d/.ignore" ]; then
      printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
    else
      cd "$d" > /dev/null
      if [ -d ".git" ]; then
        printf "%b\n" "\n${HIGHLIGHT}Updating `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
        git status | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
		git pull | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
		# TODO : Consider status
		git add . | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
		git commit -m "$now" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
		git push | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
      elif [ ! -d .svn ] && [ ! -d CVS ]; then
        scan *
      fi
      cd .. > /dev/null
    fi
  fi
  #echo "Exiting update: pwd=`pwd`"
}

function scan {
  #echo "`pwd`"
  #echo "About to scan $*"
  for x in $*; do
    update "$x"
  done
}

function updater {
  if [ "$1" != "" ]; then cd "$1" > /dev/null; fi
  printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
  scan *
}

if [ "$1" == "" ]; then
  updater
else
  for dir in "$@"; do
    updater "$dir"
  done
fi
