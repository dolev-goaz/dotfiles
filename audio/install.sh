sudo pacman -S --needed \
	pavucontrol \
	pipewire \
	pipewire-pulse \
	pulseaudio-qt

cd ~/.dotfiles
stow audio
