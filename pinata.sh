root="$(dirname $0)"

useproxy=${useproxy:-""}

pinata_auth=${pinata_auth:?"You need a pinata auth"}

Authorization="Authorization: Bearer $pinata_auth"

curl_opts="-k -sS"

function pinList() {
    local temp=`curl $curl_opts $useproxy \
    -X GET \
    -H "$Authorization" \
    https://api.pinata.cloud/data/pinList?status=pinned`

    echo $temp
}

function unpin() {
    local hashToUnpin=$1

    curl $curl_opts $useproxy \
    -X DELETE \
    -H "$Authorization" \
    https://api.pinata.cloud/pinning/unpin/$hashToUnpin
}

function pinFileToIPFS() {
    local file_path=$1
    local file_name=$(basename $file_path)

    curl $curl_opts $useproxy \
    -X POST \
    -H "$Authorization" \
    -H "Content-Type: multipart/form-data" \
    -F "file=@$file_path" \
    https://api.pinata.cloud/pinning/pinFileToIPFS
}

function unpin_all() {
    for line in `pinList | grep -oP '(?<="ipfs_pin_hash":").+?(?=")'`
    do
        echo unpinning $line
        unpin $line
        echo ""
    done
}

function pin_all() {
    local pin_path=$1

    for file in `ls $pin_path`
    do
        echo pinning $pin_path/$file
        pinFileToIPFS $pin_path/$file
        echo ""
        echo "Done"
        echo ""
    done
}

# pinFileToIPFS ./abc.txt
# unpin_all
# pinList
# pin_all .
