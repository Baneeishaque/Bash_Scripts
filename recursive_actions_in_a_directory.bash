shopt -s globstar

for i in /c/GitLab/Core-Wind_Server/db_backups/**/*
do
#  echo $i
	if [ -f "$i" ];
    then
        # printf "Path: %s\n" "${i%/*}" # shortest suffix removal
        printf "%s\n" "${i##*/}" # longest prefix removal
        # printf "Extension: %s\n"  "${i##*.}"
        # printf "Filesize: %s\n" "$(du -b "$i" | awk '{print $1}')"
        # some other command can go here
        # printf "\n\n"
    fi
done