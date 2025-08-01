shopt -s globstar

for i in /c/GitLab_BFG_Bundle/db_backups/**/*
do
#  echo $i
	if [ -f "$i" ];
    then
        # printf "Path: %s\n" "${i%/*}" # shortest suffix removal
        java -jar /C/Programs/bfg-1.13.0.jar --delete-files "${i##*/}" # longest prefix removal
        # printf "Extension: %s\n"  "${i##*.}"
        # printf "Filesize: %s\n" "$(du -b "$i" | awk '{print $1}')"
        # some other command can go here
        # printf "\n\n"
    fi
done

git reflog expire --expire=now --all && git gc --prune=now --aggressive