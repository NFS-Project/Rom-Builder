#!/usr/bin/env bash

export device="$(grep unch $HOME/script/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)"
export rom_name="$(grep init $HOME/script/build_rom.sh -m 1 | cut -d / -f 4)"
export branch_name=$(grep init $HOME/script/build_rom.sh | awk -F "-b " '{print $2}' | awk '{print $1}')
cd $HOME/$rom_name
export rel_date="$(date "+%Y%m%d")"
export file_name="$(basename out/target/product/$device/*.zip)"
telegram_message() {
         curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendMessage" \
         -d chat_id="${tg_id}" \
         -d parse_mode="HTML" \
         -d text="$1"
}
DL_LINK="https://nfsproject.projek.workers.dev/0:/$rom_name/$device/$file_name"
DATE_L="$(date +%d\ %B\ %Y)"
DATE_S="$(date +"%T")"
TXT_CAPTION="<b>✅ Build Completed Successfully ✅</b>

━━━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━━━
<b>🚀 Rom Name :- $(grep init $HOME/script/build_rom.sh -m 1 | cut -d / -f 4)</b>
<b>📁 File Name :-</b> <code>$(cd $HOME/$rom_name/out/target/product/$device && ls *zip)</code>
<b>⏰ Timer Build :- $(grep "####" $HOME/$rom_name/build.log -m 1 | cut -d '(' -f 2)</b>
<b>📱 Device :- ${device}</b>
<b>📑 Branch Build :- ${branch_name}</b>
<b>📥 Download Link :-</b> <a href=\"${DL_LINK}\">Here</a>
<b>📅 Date :- $(date +%d\ %B\ %Y)</b>
<b>🕔 Time Zone :- $(date +%T)</b>
━━━━━━━━━━━ஜ۩۞۩ஜ━━━━━━━━━━

<b>🙎 Developers :- $owner</b>"
TG_TEXT="${TXT_CAPTION}"
telegram_message "$TG_TEXT"
curl -s -X POST "https://api.telegram.org/bot${tg_token}/sendSticker" -d sticker="CAACAgQAAx0EabRMmQADi2MIwJRzA8PMsqC7tqZI5tInxv7RAAJyDgACPLQZUMeeP4x6Lf6LHgQ" -d chat_id="${tg_id}"
echo " "
rm -rf $HOME/$rom_name/out/target/product/$device
rm -rf $HOME/$rom_name/build.log
cd $HOME
rm -rf .repo*
