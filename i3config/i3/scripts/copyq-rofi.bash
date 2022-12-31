#!/usr/bin/env bash

cnt=$1

[[ -z "$cnt" ]] && cnt=5

type "copyq" >/dev/null 2>&1 &> /dev/null || (notify-send --urgency critical 'i3/copyq-rofi.bash' "Copyq not found" && exit 1)

copyq eval -- "tab('&clipboard'); for(i=$cnt; i>0; --i) print(str(read(i-1)) + '\n');"| grep "\S" | tac | rofi -dmenu -i -lines 20 -width 80 -p 'selection: '
