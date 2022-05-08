largest_size=0
largest_folder=""
while read -r i; do
    # echo "$i"
    # i2=${i: -1}
    # echo "$i2"
    if [ "${i: -1}" == "/" ]; then
        # echo "$i"
        if [[ "$i" == "VMware Images/" ]]
        then
            while read -r j; do
                # echo "$j"
                if [ "${j: -1}" == "/" ]; then
                    # echo "$j"
                    current_file_size=`rclone size "Blomp-Banee-Gmail-Drive:VMware Images/$j" --json | jq -r '.bytes'`
                    # echo $current_file_size
                    # exit 0
                    if [ "$current_file_size" -ge "$largest_size" ]; then
                        largest_size=$current_file_size
                        # echo "Blomp-Banee-Gmail-Drive:VMware Images/$j"
                        # exit 0
                        largest_folder=$(echo "Blomp-Banee-Gmail-Drive:VMware Images/$j")
                        # echo "$largest_folder : $largest_size"
                        # exit 0
                    fi
                    # echo "$largest_folder : $largest_size"
                    # exit 0
                    # echo $current_file_size | numfmt --to=iec
                    # exit 0
                    echo "Blomp-Banee-Gmail-Drive:VMware Images/$j : $(echo $current_file_size | numfmt --to=iec)"
                    # exit 0
                    # break
                fi
            done <<< $(rclone lsf Blomp-Banee-Gmail-Drive:"$i")
            # echo "$largest_folder : $largest_size"
            # exit 0
            # break
        else
            # echo "$i"
            current_file_size=`rclone size "Blomp-Banee-Gmail-Drive:$i" --json | jq -r '.bytes'`
            # echo $current_file_size
            # exit 0
            if [ "$current_file_size" -ge "$largest_size" ]; then
                largest_size=$current_file_size
                # echo "Blomp-Banee-Gmail-Drive:$i2/$j"
                # exit 0
                largest_folder=$(echo "Blomp-Banee-Gmail-Drive:$i")
                # echo "$largest_folder : $largest_size"
                # exit 0
            fi
            # echo "$largest_folder : $largest_size"
            # exit 0
            # echo $current_file_size | numfmt --to=iec
            # exit 0
            echo "Blomp-Banee-Gmail-Drive:$i : $(echo $current_file_size | numfmt --to=iec)"
            # exit 0
            # break
        fi
    fi
done <<< $(rclone lsf Blomp-Banee-Gmail-Drive:)
# exit 0
echo "Largest folder: $largest_folder, size: $(echo $largest_size | numfmt --to=iec)"
