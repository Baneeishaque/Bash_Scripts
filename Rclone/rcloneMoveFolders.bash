rclone lsf Blomp-Banee-Gmail-Drive: | while read -r i; do
    # echo "$i"
    if [ "$i" != "Windows XP SP2/" ] && [ "$i" != "genymotion_vbox86p_10.0_210203_090317.ova" ] && [ "$i" != "VMware Images/" ]; then
        i2=${i::-1}
        # echo "$i2"
        rclone lsf Blomp-Banee-Gmail-Drive:"$i2" | while read -r j; do
            # echo "$j"
            # rclone move "Blomp-Banee-Gmail-Drive:$i2/$j" "Blomp-Banee-Gmail-Drive:VMware Images/$i2 VMware/" --dry-run --log-level DEBUG
            # rclone move "Blomp-Banee-Gmail-Drive:$i2/$j" "Blomp-Banee-Gmail-Drive:VMware Images/$i2 VMware/" --dry-run
            rclone move "Blomp-Banee-Gmail-Drive:$i2/$j" "Blomp-Banee-Gmail-Drive:VMware Images/$i2 VMware/"
        done
    fi
done

# rclone lsf "Blomp-Banee-Gmail-Drive:VMware Images/Ubuntu Server 20.04 x64 VMware/" | while read -r i; do
#     echo "$i"
#     rclone lsf Blomp-Banee-Gmail-Drive:"VMware Images/Ubuntu Server 20.04 x64 VMware/$i" | while read -r j; do
#         echo "$j"
#         rclone move "Blomp-Banee-Gmail-Drive:VMware Images/Ubuntu Server 20.04 x64 VMware/$i/$j" "Blomp-Banee-Gmail-Drive:VMware Images/Ubuntu Server 20.04 x64 VMware/" --create-empty-src-dirs --delete-empty-src-dirs --dry-run --log-level DEBUG
#         # rclone move "Blomp-Banee-Gmail-Drive:VMware Images/Ubuntu Server 20.04 x64 VMware/$i/$j" "Blomp-Banee-Gmail-Drive:VMware Images/Ubuntu Server 20.04 x64 VMware/" --create-empty-src-dirs --delete-empty-src-dirs --log-level DEBUG
#     done
# done
