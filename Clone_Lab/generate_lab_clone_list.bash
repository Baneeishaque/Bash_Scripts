#!/bin/bash

# Update all git directories below current directory or specified directory
# Skips directories that contain a file called .ignore
#
# Using printf insteach of echo -e for Mac OS
# See http://stackoverflow.com/questions/4435853/echo-outputs-e-parameter-in-bash-scripts-how-can-i-prevent-this

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
		PRE=`pwd`
		printf "git clone `git config --get remote.origin.url` ${PRE//$CURRENT_DIRECTORY/}\n" >> $CURRENT_DIRECTORY/Lab.txt
		# printf "git clone `git config --get remote.origin.url` " >> $CURRENT_DIRECTORY/Lab.txt
		# printf '%s\n' "${`pwd`//$CURRENT_DIRECTORY/}"
      elif [ ! -d .svn ] && [ ! -d CVS ]; then
        scan *
      fi
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

rm Lab.txt

if [ "$1" == "" ]; then
  updater
else
  for dir in "$@"; do
    updater "$dir"
  done
fi
