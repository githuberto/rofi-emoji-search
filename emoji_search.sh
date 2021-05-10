#!/bin/bash
# 
# This script will used by Rofi (the mode is defined in config.rasi).
#
# Rofi will run it twice. The first time, it will be run with no arguments and
# send the list of emojis as menu options via stdout. The second time, it will
# be given the user's selection as an argument (if successful ) and copy the 
# emoji to the clipboard.
#
# To make a shortcut, something like this to your i3 config.
#   bindsym $mod+grave exec rofi -show 'Emoji Search🔎' -config ~/.config/rofi-emoji-search/config.rasi

# Send the list of emojis if this is the first (no-args) call.
if [[ -z "$@" ]]; then
  cat ~/.config/rofi-emoji-search/emoji_list.txt
  exit 0
fi

emoji="$(echo ${1} | awk ' { print $1 }' | tr -d '\n')"

# Ensure the emoji is from the selection (not random failed letters).
if [[ -z $(grep ${emoji} ~/emoji/emoji_list.txt) ]]; then
  notify-send "❌ Invalid emoji search: ${emoji}" -t 5000
  exit 1
fi

echo -n "${emoji}" | xclip -sel clip >& /dev/null
notify-send "Copied ${emoji} to clipboard." --expire-time=5000
