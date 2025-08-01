mdl() {
    url=$(curl -Lqs "$1" | grep "href.*download.*media.*" | tail -1 | cut -d '"' -f 2)
    # TODO : Check for aria2c
    aria2c -x 6 "$url" # or wget "$url" if you prefer.
}
