~/.local/bin/waybar-scss-compile.sh
killall waybar

# ----- debugging -----
if [ "$1" = "-d" ]; then
	export GTK_DEBUG=interactive
fi

waybar &
