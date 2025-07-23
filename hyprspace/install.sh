# Clone if doesn't exist
if [ ! -e "$HOME/.config/hypr/plugins/Hyprspace" ]; then
	mkdir -p ~/.config/hypr/plugins
	cd ~/.config/hypr/plugins
	git clone https://github.com/KZDKM/Hyprspace.git Hyprspace
fi
cd ~/.config/hypr/plugins/Hyprspace

# Check for updates
PRE=$(git rev-parse HEAD)
git pull --quiet
POST=$(git rev-parse HEAD)
if [ "$PRE" = "$POST" ]; then
	echo "Hyprspace is already up to date."
	exit 0
fi

# unload if .so file exists
if [ -e "$HOME/.config/hypr/plugins/Hyprspace/Hyprspace.so" ]; then
	hyprctl plugin unload ~/.config/hypr/plugins/Hyprspace/Hyprspace.so
fi
make all
hyprctl plugin load ~/.config/hypr/plugins/Hyprspace/Hyprspace.so
