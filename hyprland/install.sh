sudo pacman -S --needed \
	hyprland \
	hyprshot \
	hyprpicker \
	xdg-desktop-portal-hyprland \
	lxqt-policykit \
	gnome-keyring \
	seahorse \
	network-manager-applet

sudo systemctl disable NetworkManager-wait-online.service

# xdg-desktop-portal-hyprland is needed for screen sharing in browsers and other apps

yay -S --needed \
	clipse \
	clipse-gui \
	ferdium \
	opentabletdriver

systemctl --user enable --now opentabletdriver.service

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
