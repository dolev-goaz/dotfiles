hyprctl dispatch togglespecialworkspace chats

if ! pgrep -f ferdium >/dev/null; then
	hyprctl dispatch exec "[workspace special:chats] ferdium"
	sleep 0.5 # Give it a moment to start before toggling
fi
