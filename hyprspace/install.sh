# Clone if doesn't exist
alreadyExisting=true
if [ ! -e "$HOME/.config/hypr/plugins/Hyprspace" ]; then
	mkdir -p ~/.config/hypr/plugins
	cd ~/.config/hypr/plugins
	git clone https://github.com/KZDKM/Hyprspace.git Hyprspace
	alreadyExisting=false
fi
cd ~/.config/hypr/plugins/Hyprspace

# unload if .so file exists
if [ -e "$HOME/.config/hypr/plugins/Hyprspace/Hyprspace.so" ]; then
	hyprctl plugin unload ~/.config/hypr/plugins/Hyprspace/Hyprspace.so
fi
make all
hyprctl plugin load ~/.config/hypr/plugins/Hyprspace/Hyprspace.so

cd ~/.dotfiles
stow hyprspace
