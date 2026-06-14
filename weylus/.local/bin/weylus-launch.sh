hyprctl output create headless Virtual-1
weylus \
	--bind-address "0.0.0.0" \
	--web-port 1701 \
	--gui-theme dark \
	--wayland-support \
	--auto-start \
	--try-nvenc \
	--access-code="I AM DOLEV"
adb reverse tcp:1701 tcp:1701
