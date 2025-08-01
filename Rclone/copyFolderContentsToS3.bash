# ls -d */
# search_dir=/workspace/Blomp-Banee3-Gmail-Drive
# for entry in "$search_dir"/*
# do
#   echo "$entry"
# done
find . -type f | sed 's/^\.\///g' | while read -r i; do
    # echo "$i"
    # rclone --config ../configurations-private/rclone.conf copy "$i" Storj-Banee2-Gmail:files/ --progress --progress-terminal-title --human-readable --log-level DEBUG --dry-run
    rclone --config ../configurations-private/rclone.conf copy "$i" Storj-Banee2-Gmail:files/ --progress --progress-terminal-title --human-readable --log-level DEBUG
done
