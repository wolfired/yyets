function ipfs_is_running() {
    ipfs swarm peers 1>/dev/null 2>&1
    if [[ 0 -ne $? ]]; then
        return
    fi
    echo "TRUE"
}

function ipfs_is_key_exist() {
    local exist=`ipfs key list | grep -oP $ipfs_key_name`
    if [[ ! -n $exist ]]; then
        return
    fi
    echo "TRUE"
}

function ipfs_gen_key() {
    local exist=`ipfs_is_key_exist`
    if [[ -n $exist ]]; then
        # echo "ipfs key '$ipfs_key_name' exist"
        return
    fi
    if [[ -f "$root/$ipfs_key_name.key" ]]; then
        echo "import ipfs key from key file: '$root/$ipfs_key_name.key'"
        ipfs key import $ipfs_key_name "$root/$ipfs_key_name.key"
        return
    fi
    if [[ -n $(ipfs_is_running) ]]; then
        echo "ipfs is running, export ipfs key need ipfs stopped"
        exit 1
    fi
    echo "gen ipfs key: '$ipfs_key_name'"
    ipfs key gen $ipfs_key_name
    echo "export ipfs key to file: '$root/$ipfs_key_name.key'"
    ipfs key export -o=$root/$ipfs_key_name.key $ipfs_key_name
}

function ipfs_add_dir() {
    local dir_path=$1
    local dir_name=$(basename $dir_path)

    ipfs add -Q -r $dir_path
}

function ipfs_cp_dir() {
    local dir_hash=$1
    local dir_host=$2
    # ipfs files rm -r $dir_host
    ipfs files mkdir -p $(dirname $dir_host)
    ipfs files cp /ipfs/$dir_hash $dir_host
}

function ipfs_name() {
    local dir_hash=$1
    ipfs name publish --key=$ipfs_key_name /ipfs/$dir_hash
}