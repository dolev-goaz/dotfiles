~/.local/bin/waybar-verify-action.sh "Update System"

if [ $? -ne 0 ]; then
	exit 1
fi

notify-send "Update started" "System update started in new terminal." --icon=dialog-information
wezterm start -- zsh -c "~/scripts/update-arch.sh; echo 'Press any key to continue'; read -n 1 -s -r"
notify-send "Update finished" "System update finished." --icon=dialog-information
