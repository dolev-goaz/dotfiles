#!/usr/bin/env bash
# docs- https://wiki.hypr.land/hyprland-wiki/pages/IPC/
set -euo pipefail

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# wait for socket to appear (timeout ~ 15s)
for i in {1..150}; do
	[ -S "$SOCKET" ] && break
	sleep 0.1
done
if [ ! -S "$SOCKET" ]; then
	echo "Hyprland socket2 not found at: $SOCKET" >&2
	exit 1
fi

socat - UNIX-CONNECT:"$SOCKET" | while IFS= read -r line; do
	# activelayout events look like: activelayout>>KEYBOARDNAME,LAYOUTNAME
	if [[ $line == "activelayout>"* ]]; then
		layout=$(awk -F ',' '{print $2}' <<<"$line")
		echo "$layout"
	fi
done
