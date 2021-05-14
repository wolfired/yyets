root="$(dirname $0)"

source ~/workspace_git/linuxcfg/utils/config.sh
source ~/workspace_git/linuxcfg/utils/ipfs/lab.sh
source ~/workspace_git/linuxcfg/utils/pinata/lab.sh

source ./config.sh

ipfs_gen_key $ipfs_key_name $ipfs_key_file

pinata_unpin_all
pinata_pin_all ./web/dist

echo ""

dir_hash=$(ipfs_add_dir ./web/dist)
ipfs_cp_dir $dir_hash $ipfs_host_dir
ipfs_name_publish $dir_hash $ipfs_key_name