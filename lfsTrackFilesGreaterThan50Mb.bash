find * -type f -size +50M -print0 | while read -r -d '' line; do git lfs track "$line"; done
