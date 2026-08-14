CUSTOM_CLASS="btop-terminal"
WORKSPACE_NAME="system-manager"

WORKSPACE=$(hyprctl workspaces -j | jq -r ".[] | select(.name == \"special:$WORKSPACE_NAME\")")
RUNNING_BTOP_PID=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CUSTOM_CLASS\") | .pid")

if [ -z "$WORKSPACE" ] && [ -z "$RUNNING_BTOP_PID" ]; then
	hyprctl dispatch "hl.dsp.exec_cmd('wezterm start --class $CUSTOM_CLASS -- zsh -c btop', { workspace = 'special:$WORKSPACE_NAME' })"
fi

hyprctl dispatch "hl.dsp.workspace.toggle_special('$WORKSPACE_NAME')"
