sudo pacman -S --needed \
	hyprland \
	hyprshot \
	thunar \
	swaync

yay -S --needed \
	clipse \
	clipse-gui

# Hyprspace- https://github.com/KZDKM/Hyprspace
if ! hyprpm list | grep -q -i "Hyprspace"; then
	hyprpm add https://github.com/KZDKM/Hyprspace
	hyprpm enable Hyprspace
fi
