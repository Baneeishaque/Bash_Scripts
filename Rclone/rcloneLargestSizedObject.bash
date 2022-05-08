largest_size=0
largest_file=""
while read -r i; do
    # echo "$i"
    if [ "$i" != "Windows XP SP2/" ] && [ "$i" != "genymotion_vbox86p_10.0_210203_090317.ova" ] && [ "$i" != "VMware Images/" ]; then
        while read -r j; do
            # echo "$j"
            i2=${i::-1}
            # echo "$i2"
            current_file_size=`rclone size "Blomp-Banee-Gmail-Drive:$i2/$j" --json | jq -r '.bytes'`
            # echo $current_file_size
            # exit 0
            if [ "$current_file_size" -ge "$largest_size" ]; then
                largest_size=$current_file_size
                # echo "Blomp-Banee-Gmail-Drive:$i2/$j"
                # exit 0
                largest_file=$(echo "Blomp-Banee-Gmail-Drive:$i2/$j")
                # echo "$largest_file : $largest_size"
                # exit 0
            fi
            # echo "$largest_file : $largest_size"
            # exit 0
            # echo $current_file_size | numfmt --to=iec
            # exit 0
            echo "Blomp-Banee-Gmail-Drive:$i2/$j : $(echo $current_file_size | numfmt --to=iec)"
            # exit 0
            # break
        done <<< $(rclone lsf Blomp-Banee-Gmail-Drive:"$i")
        # echo "$largest_file : $largest_size"
        # exit 0
        # break
    fi
done <<< $(rclone lsf Blomp-Banee-Gmail-Drive:)
# exit 0
echo "Largest file: $largest_file, size: $(echo $largest_size | numfmt --to=iec)"
