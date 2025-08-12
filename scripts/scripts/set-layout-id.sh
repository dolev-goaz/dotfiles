#!/bin/bash
set -eu

layout_id="$1"
if [ -z "$layout_id" ]; then
	echo "Usage: $0 <layout_id>"
	exit 1
fi

keyboard=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .name')

hyprctl switchxkblayout "$keyboard" "$layout_id"
