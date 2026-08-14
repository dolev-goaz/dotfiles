hyprctl dispatch 'hl.dsp.workspace.toggle_special("chats")'

if ! pgrep -f ferdium >/dev/null; then
	hyprctl dispatch 'hl.dsp.exec_cmd("ferdium", { workspace = "special:chats" })'
	sleep 0.5
fi
