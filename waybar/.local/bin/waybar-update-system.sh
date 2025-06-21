~/.local/bin/waybar-verify-action.sh "Update System"

if [ $? -ne 0 ]; then
	exit 1
fi

export SUDO_ASKPASS="$HOME/.local/bin/waybar-ask-password.sh"

if ! sudo -A -k true 2>/dev/null; then
	notify-send "Update cancelled" "Wrong password or cancelled by user."
	exit 1
fi

log=$(mktemp)

~/scripts/update-arch.sh &>"$log" &
update_pid=$!
notify-send "Updating system" "Update PID: $update_pid\nUpdate Log: $log" --icon=dialog-information

wezterm start -- zsh -c "tail -f $log"
wait "$update_pid"
notify-send "Update complete" "Your system has been updated successfully."
rm "$log"
