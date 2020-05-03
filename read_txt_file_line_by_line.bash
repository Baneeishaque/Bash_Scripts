#!/bin/bash
input="/C/Users/Administrator/non_git_folders.txt"
while IFS= read -r line
do
  # echo "$line"
  cd $line
  echo `pwd`
  touch .ignore
  # ls --all
done < "$input"