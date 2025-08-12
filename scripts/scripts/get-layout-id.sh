#!/bin/bash
set -eu

input_layout="$1"

if [ -z "$input_layout" ]; then
	echo "Usage: $0 <input_layout>"
	exit 1
fi

keyboard=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true)')
layouts=$(echo "$keyboard" | jq -r '.layout')

index=$(echo "$layouts" | tr ',' '\n' | grep -n -F "$input_layout" | cut -d: -f1)
echo "$((index - 1))"
