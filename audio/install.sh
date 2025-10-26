sudo pacman -S --needed \
	pavucontrol \
	pipewire \
	pipewire-pulse \
	pulseaudio-qt

cd ~/.dotfiles
stow audio
systemctl --user enable --now ~/.config/systemd/user/volume-notify.service
