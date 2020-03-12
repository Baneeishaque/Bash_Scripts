#!/bin/bash

# From ScalaCourses.com Introduction to Play Framework with Scala course

# Update all git directories below current directory or specified directory
# Skips directories that contain a file called .ignore
#
# Using printf insteach of echo -e for Mac OS
# See http://stackoverflow.com/questions/4435853/echo-outputs-e-parameter-in-bash-scripts-how-can-i-prevent-this

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

function update {
  local d="$1"
  if [ -d "$d" ]; then
    #echo "Looking for $d/.ignore"
    if [ -e "$d/.ignore" ]; then
      printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
    else
      cd "$d" > /dev/null
      if [ -f "gradlew" ]; then
        printf "%b\n" "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
        #dos2unix gradlew
        # chmod +x gradlew
        ./gradlew build
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
  printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
  scan *
}

if [ "$1" == "" ]; then
  updater
else
  for dir in "$@"; do
    updater "$dir"
  done
fi
