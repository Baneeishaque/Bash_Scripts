#!/bin/bash

# Skips directories that contain a file called .ignore

# Check Spaces on Lab_Unclone.txt

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
CURRENT_DIRECTORY=`pwd`

function update {
  local d="$1"
  if [ -d "$d" ]; then
	printf "\nLooking for $d/.ignore\n"
    if [ -e "$d/.ignore" ]; then
      printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}\n"
    else
      cd "$d" > /dev/null
      if [ -d ".git" ]; then
        printf "${HIGHLIGHT}Working on `pwd`$NORMAL\n"
		# printf "git clone `git config --get remote.origin.url` %s\n" "${PWD##*/}" >> $CURRENT_DIRECTORY/Lab.txt
		local REMOTE_URL=`git config --get remote.origin.url`
		local PRESENT_DIRECTORY=`pwd`
		if [ ! -z $REMOTE_URL ]; then
			printf "git clone $(perl -MURI::Escape -e 'print uri_unescape($ARGV[0])' "$REMOTE_URL") ${PRESENT_DIRECTORY//"$CURRENT_DIRECTORY/"/}\n" >> $CURRENT_DIRECTORY/Lab.txt
		else
			printf "${PRESENT_DIRECTORY//"$CURRENT_DIRECTORY/"/}\n" >> $CURRENT_DIRECTORY/Lab_Unclone.txt
		fi
		# check for remote url repos
      elif [ ! -d .svn ] && [ ! -d CVS ]; then
        scan *
      fi
		# list non-git directories - filter ide repo folders
      cd .. > /dev/null
    fi
  fi
  printf "Exiting from `pwd`\n"
}

function scan {
  # printf "`pwd`"
  printf "About to scan $*\n"
  for x in $*; do
    update "$x"
  done
}

function updater {
  if [ "$1" != "" ]; then cd "$1" > /dev/null; fi
  printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}\n"
  scan *
}

if test -f "Lab.txt"; then
	rm Lab.txt
fi

if test -f "Lab_Unclone.txt"; then
	rm Lab.txt
fi

if [ "$1" == "" ]; then
  updater
else
  for dir in "$@"; do
    updater "$dir"
  done
fi
