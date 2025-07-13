sudo pacman -S --needed \
	hyprland \
	hyprshot \
	thunar \
	swaync

yay -S --needed \
	clipse \
	clipse-gui

# For hyprpm
sudo pacman -S --needed \
    cmake \
    meson \
    cpio \
    pkgconf \
    git \
    gcc

# Hyprspace- https://github.com/KZDKM/Hyprspace
if ! hyprpm list | grep -q -i "Hyprspace"; then
    hyprpm update
	hyprpm add https://github.com/KZDKM/Hyprspace
	hyprpm enable Hyprspace
fi
