CUSTOM_CLASS="btop-terminal"
WORKSPACE_NAME="system-manager"

WORKSPACE=$(hyprctl workspaces -j | jq -r ".[] | select(.name == \"special:$WORKSPACE_NAME\")")
RUNNING_BTOP_PID=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CUSTOM_CLASS\") | .pid")

if [ -z "$WORKSPACE" ] && [ -z "$RUNNING_BTOP_PID"]; then
	hyprctl dispatch exec "[workspace special:$WORKSPACE_NAME] wezterm start --class $CUSTOM_CLASS -- zsh -c btop"
fi
hyprctl dispatch togglespecialworkspace "$WORKSPACE_NAME"
