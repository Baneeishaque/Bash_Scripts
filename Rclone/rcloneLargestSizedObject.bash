remote=Storj-Banee7-Gmail
rcloneConfiguration=/workspace/configurations-private/rclone.conf
largest_size=0
largest_file=""
while read -r i; do
    # echo "$i"
    # echo "$i"
    i2=${i#* }
    # echo "$i2"
    # exit 0
    current_file_size=$(rclone size "$remote:$i2" --json --config $rcloneConfiguration | jq -r '.bytes')
    # echo $current_file_size
    # exit 0
    if [ "$current_file_size" -ge "$largest_size" ]; then
        largest_size=$current_file_size
        # echo "$remote:$i2"
        # exit 0
        largest_file=$(echo "$remote:$i2")
        # echo "$largest_file : $largest_size"
        # exit 0
    fi
    # echo "$largest_file : $largest_size"
    # exit 0
    # echo $current_file_size | numfmt --to=iec
    # exit 0
    echo "$remote:$i2 : $(echo $current_file_size | numfmt --to=iec)"
    # exit 0
    # break
done <<<$(rclone ls $remote: --config $rcloneConfiguration --min-size 1G)
# exit 0
echo "Largest file: $largest_file, size: $(echo $largest_size | numfmt --to=iec)"
