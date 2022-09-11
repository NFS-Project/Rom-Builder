# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/xdroid-oss/xd_manifest -b thirteen -g default,-mips,-darwin,-notdefault
git clone https://github.com/NFS-project/local_manifest --depth 1 -b 13 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch xdroid_rosy-userdebug
export TZ=Asia/Jakarta
export KBUILD_BUILD_USER=rosy
export KBUILD_BUILD_HOST=nfsproject
export BUILD_USERNAME=rosy
export BUILD_HOSTNAME=nfsproject
export use_GrapheneCamera=true
export USE_NFSparts=true
export ARROW_BETA=true
curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" -d chat_id="${tg_id}" -d "disable_web_page_preview=true" -d "parse_mode=html" -d text="===================================%0A<b>($(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1))</b> Building Started%0A<b>ROM:</b> $rom_name%0A$(echo "${var_cache_report_config}")"
make xd

# end 
