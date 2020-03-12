for i in `cordova plugin ls | grep '^[^ ]*' -o`; do echo cordova plugin rm $i; done
