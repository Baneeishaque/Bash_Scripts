#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        echo snap remove "$snapname" --revision="$revision"
        snap remove "$snapname" --revision="$revision"
    done
