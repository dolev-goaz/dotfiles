if pgrep -x "weylus" >/dev/null; then
	killall weylus
	fuser -k 1701/tcp
fi

# Virtual monitor for weylus
VIRTUAL_MONITOR_NAME="Virtual-1"
MONITOR_EXISTS=$(hyprctl monitors -j | jq --arg name "$VIRTUAL_MONITOR_NAME" 'any(.[]; .name == $name)')
if [ "$MONITOR_EXISTS" = "false" ]; then
	hyprctl output create headless "$VIRTUAL_MONITOR_NAME"
fi

adb reverse tcp:1701 tcp:1701

# can pass --no-gui to run in the background
weylus \
	--no-gui \
	--bind-address "0.0.0.0" \
	--web-port 1701 \
	--gui-theme dark \
	--wayland-support \
	--auto-start \
	--try-nvenc \
	--access-code="I AM DOLEV"
