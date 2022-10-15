# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/bananadroid/android_manifest.git -b 12
git clone https://github.com/NFS-Project/local_manifest --depth 1 -b banana-12 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
export TZ=Asia/Jakarta
export BUILD_USERNAME=zacky
export BUILD_HOSTNAME=ubuntu-22.04
export ALLOW_MISSING_DEPENDENCIES=true
lunch banana_ginkgo-user
curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" -d chat_id="${tg_id}" -d "disable_web_page_preview=true" -d "parse_mode=html" -d text="===================================%0A<b>($(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1))</b> Building Started%0A<b>ROM:</b> $rom_name%0A$(echo "${var_cache_report_config}")"
m banana

