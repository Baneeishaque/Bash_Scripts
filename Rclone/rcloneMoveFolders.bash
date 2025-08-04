rclone lsf Blomp-Banee3-Gmail-Drive: | while read -r i; do
    # echo "$i"
    if [ "$i" != "IE8.Win7.VirtualBox.zip" ] && [ "$i" != "VMware Images/" ]; then
        # echo "$i"
        i2=${i::-1}
        # echo "$i2"
        rclone lsf Blomp-Banee3-Gmail-Drive:"$i2" | while read -r j; do
            # echo "$j"
            rclone move "Blomp-Banee3-Gmail-Drive:$i2/$j" "Blomp-Banee3-Gmail-Drive:VMware Images/$i2 VMware/" --create-empty-src-dirs --delete-empty-src-dirs --dry-run --log-level DEBUG
            # rclone move "Blomp-Banee3-Gmail-Drive:$i2/$j" "Blomp-Banee3-Gmail-Drive:VMware Images/$i2 VMware/" --create-empty-src-dirs --delete-empty-src-dirs --log-level DEBUG
        done
    fi
done
