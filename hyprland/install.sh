sudo pacman -S --needed \
	hyprland \
	hyprshot \
	hyprpicker \
	swaync \
	xdg-desktop-portal-hyprland

# xdg-desktop-portal-hyprland is needed for screen sharing in browsers and other apps

yay -S --needed \
	clipse \
	clipse-gui \
	ferdium \
	opentabletdriver

# For hyprpm
sudo pacman -S --needed \
	cmake \
	meson \
	cpio \
	pkgconf \
	git \
	gcc

cd ~/.dotfiles
stow hyprland
hyprctl reload
