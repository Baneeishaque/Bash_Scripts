#!/bin/bash

# Skips directories that contain a file called .ignore

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
        ./gradlew buildDebug --build-cache --configure-on-demand --no-parallel --max-workers=1
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
