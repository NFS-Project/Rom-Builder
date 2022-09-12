# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/xdroid-oss/xd_manifest -b thirteen default,-mips,-darwin,-notdefault
#git clone https://github.com/NFS-Project/local_manifest --depth 1 -b whyred-nad-10 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
export TZ=Asia/Jakarta
export BUILD_USERNAME=zacky
export BUILD_HOSTNAME=ubuntu-22.04
export ALLOW_MISSING_DEPENDENCIES=true
lunch xdroid_whyred-user
curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" -d chat_id="${tg_id}" -d "disable_web_page_preview=true" -d "parse_mode=html" -d text="===================================%0A<b>($(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1))</b> Building Started%0A<b>ROM:</b> $rom_name%0A$(echo "${var_cache_report_config}")"
make xd

