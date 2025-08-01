#!/bin/bash

# Base script for git operations with dummy functions to override

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

# Dummy function to be overridden - called before git operations
function pre_git_operation {
    local repo_path="$1"
    # Override this function to add pre-operation logic
    return 0
}

# Dummy function to be overridden - called for git operations
function git_operation {
    local repo_path="$1"
    # Override this function to add git operation logic (pull, push, etc.)
    return 0
}

# Dummy function to be overridden - called after git operations
function post_git_operation {
    local repo_path="$1"
    # Override this function to add post-operation logic
    return 0
}

function update {
    printf "%b\n" "${HIGHLIGHT}Updating $1${NORMAL}"
    local d="$1"
    if [ -d "$d" ]; then
        printf "DEBUG: Entered directory check for $d\n"
        if [ -e "$d/.ignore" ]; then
            printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
        else
            cd "$d" >/dev/null
            printf "DEBUG: Now in $(pwd)\n"
            if [ -d ".git" ]; then
                printf "%b\n" "\n${HIGHLIGHT}Processing $(pwd)${NORMAL}"
                pre_git_operation "$(pwd)"
                git_operation "$(pwd)"
                post_git_operation "$(pwd)"
            elif [ ! -d .svn ] && [ ! -d CVS ]; then
                scan *
            fi
            cd .. >/dev/null
        fi
    fi
}

function scan {
    printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
    for x in *; do
        [ -d "$x" ] && update "$x"
    done
}

function updater {
    if [ "$1" != "" ]; then cd "$1" >/dev/null; fi
    printf "%b\n" "${HIGHLIGHT}Starting update in $(pwd)${NORMAL}"
    scan *
}

function run_updater_entrypoint {
    if [ "$1" == "" ]; then
        updater
    else
        for dir in "$@"; do
            updater "$dir"
        done
    fi
}
