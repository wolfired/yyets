root="$(dirname $0)"

source $root/config.sh
source $root/ipfs.sh
source $root/pinata.sh

ipfs_gen_key

# if [[ ! -n $(ipfs_is_running) ]]; then
#     echo "ipfs is stop"
#     exit 1
# fi

# unpin_all
pin_all ./out

# dir_hash=$(ipfs_add_dir ./out)
# ipfs_cp_dir $dir_hash $ipfs_host_dir
# ipfs_name $dir_hash