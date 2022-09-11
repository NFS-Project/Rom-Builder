#!/usr/bin/env bash

export device="$(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)"
export rom_name="$(grep init $HOME/script/build_rom.sh -m 1 | cut -d / -f 4)"
export rel_date="$(date "+%Y%m%d")"
export branch_name=$(grep init $HOME/script/build_rom.sh | awk -F "-b " '{print $2}' | awk '{print $1}')
export rel_date="$(date "+%Y%m%d")"
export shasum="out/target/product/$device/*$rel_date*.zip*sha*"
export ota="out/target/product/$device/*ota*.zip"

cd $HOME/$rom_name
rm -rf $shasum
rm -rf $ota
cd $HOME/$rom_name/out/target/product/$device
rclone copy --drive-chunk-size 256M --stats 1s *.zip NFS:$rom_name/$device -P
