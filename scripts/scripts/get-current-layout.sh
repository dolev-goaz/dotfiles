#!/bin/bash
set -eu

keyboard=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true)')
active_keymap=$(echo "$keyboard" | jq -r '.active_keymap')

active_layout=$(grep -iF "$active_keymap" /usr/share/X11/xkb/rules/base.lst 2>/dev/null | awk '{print $1}' | head -n1)
echo "$active_layout"
