#!/usr/bin/env bash

export device="$(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)"
export rom_name="$(grep init $HOME/script/build_rom.sh -m 1 | cut -d / -f 4)"
export command="$(tail $HOME/script/build_rom.sh -n +$(expr $(grep '# build rom' $HOME/script/build_rom.sh -n | cut -f1 -d:) - 1)| head -n -1 | grep -v '# end')"
export rel_date="$(date "+%Y%m%d")"

cd $HOME/$rom_name
export CCACHE_DIR=$HOME/ccache/$rom_name/$device
export CCACHE_EXEC=/usr/bin/ccache
export USE_CCACHE=1
ccache -o compression=true
ccache -o compression_level=1
ccache -o max_size=50G
ccache -z
ls device/*/*/vendorsetup.sh | grep -v generic && curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" -d chat_id="${tg_id}" -d "disable_web_page_preview=true" -d "parse_mode=html" -d text="<b>($(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1))</b> Building Failed 🚫%0A%0A<b>Harap hapus file vendorsetup.sh dari tree anda dan gunakan manifest lokal untuk mengkloning atau menghapus repositori. Terima kasih.😉</b>" && curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendSticker" -d sticker="CAACAgQAAx0EabRMmQACBQ9jHFumUd8csxYXNUa-EsvpVPZqbAAC4AkAAu9GYFGTgHavjO_HLh4E" -d chat_id="${tg_id}" && exit 1 || true
bash -c "$command" |& tee -a $HOME/$rom_name/build.log || true
a=$(grep 'FAILED:' build.log -m1 || true)
if [[ $a == *'FAILED:'* ]]
then
curl -F document=@build.log "https://api.telegram.org/bot${tg_token}/sendDocument" \
    -F chat_id="${tg_id}" \
    -F "disable_web_page_preview=true" \
    -F "parse_mode=html" \
    -F caption="⛔${device} Build $rom_name Error⛔

Mohon bersabar ini ujian, Kalao gk sabar ya banting aja HP nya awowok😅"
curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendSticker" -d sticker="CAACAgQAAx0EabRMmQACAvhjEpueqrNRuGJo5vCfzrjjnFH1gAACagoAAtMOGVGNqOvAKmWo-h4E" -d chat_id="${tg_id}"
rm -rf build.log
exit 1
fi
