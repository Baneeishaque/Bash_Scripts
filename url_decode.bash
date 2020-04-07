encoded_url="https://baneeishaque%40gmail.com@github.com/Baneeishaque/laravel-test.git"
decoded_url=$(perl -MURI::Escape -e 'print uri_unescape($ARGV[0])' "$encoded_url")
echo $decoded_url