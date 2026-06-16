if pgrep -x "weylus" >/dev/null; then
	echo "Stopping existing weylus instances..."
	killall weylus
	fuser -k 1701/tcp
fi

# Virtual monitor for weylus
VIRTUAL_MONITOR_NAME="Virtual-1"
VIRTUAL_MONITOR_PREEXISTS=$(hyprctl monitors -j | jq --arg name "$VIRTUAL_MONITOR_NAME" 'any(.[]; .name == $name)')
echo "Virtual monitor preexists: $VIRTUAL_MONITOR_PREEXISTS"

echo "Setting up ADB reverse port forwarding..."
adb reverse tcp:1701 tcp:1701 2>/dev/null

start_weylus() {
	# can pass --no-gui to run in the background
	WEYLUS_LOG_LEVEL=DEBUG WEYLUS_LOG_JSON=true weylus \
		--no-gui \
		--bind-address "0.0.0.0" \
		--web-port 1701 \
		--gui-theme dark \
		--wayland-support \
		--auto-start \
		--try-nvenc \
		--access-code="I AM DOLEV" 2>&1
}

cleanup() {
	trap - EXIT SIGINT SIGTERM # only run once
	echo "Cleaning up weylus and virtual monitor..."
	if [ "$VIRTUAL_MONITOR_PREEXISTS" = "false" ]; then
		hyprctl output remove "$VIRTUAL_MONITOR_NAME" 2>/dev/null
	fi
	adb reverse --remove tcp:1701
}
trap cleanup EXIT SIGINT SIGTERM

connected_count=0
connection_requests=0

echo "Launching weylus..."
start_weylus | while read -r line; do
	MESSAGE=$(echo "$line" | jq -r ".fields.message" 2>/dev/null)
	if [[ "$MESSAGE" = "Client connected." ]]; then
		connection_requests=$((connection_requests + 1))
		if [ "$connection_requests" -eq 3 ]; then
			connected_count=$((connected_count + 1))
			echo "Client connected. Current connected count: $connected_count"
			if [ "$VIRTUAL_MONITOR_PREEXISTS" = "false" ]; then
				echo "Creating virtual monitor for weylus..."
				hyprctl output create headless "$VIRTUAL_MONITOR_NAME"
			fi
		fi
	fi

	if [[ "$MESSAGE" = "Invalid websocket frame: Unexpected EOF." ]]; then
		connected_count=$((connected_count - 1))
		echo "Client disconnected. Current connected count: $connected_count"
		if [ "$connected_count" -eq 0 ]; then
			echo "No clients connected. Cleaning up virtual monitor if it was created by this script."
			if [ "$VIRTUAL_MONITOR_PREEXISTS" = "false" ]; then
				hyprctl output remove "$VIRTUAL_MONITOR_NAME"
				echo "Virtual monitor removed."
			fi
		fi
	fi
done
