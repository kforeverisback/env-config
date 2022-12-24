#!/usr/bin/env bash

screenshot_file=/tmp/i3lock.jpg
list_programs=(scrot maim i3-scrot)

for p in "${list_programs[@]}" ; do type "$p" >/dev/null 2>&1 &> /dev/null && program=$p && break; done
[[ -z "$program" ]] && notify-send --urgency critical 'i3/blur-lock.bash' "No screenshot program found from: ${list_programs[*]// /,}"
cmd="$program $screenshot_file"

BLUR="5x4"
SCALE="20%"
RESIZE="500%"

$cmd
type convert >/dev/null 2>&1 || notify-send --urgency critical 'i3/blur-lock.bash' "ImageMagik 'convert' not found"
convert $screenshot_file -scale $SCALE -blur $BLUR -resize $RESIZE $screenshot_file
echo "Last locked at $(date)" >| /tmp/last-lock-status
i3lock -i $screenshot_file
rm $screenshot_file

# Turn the screen off after a delay.
sleep 120; pgrep i3lock && xset dpms force off
