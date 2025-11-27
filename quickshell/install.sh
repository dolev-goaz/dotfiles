yay -S --needed \
	quickshell-git

sudo pacman -S --needed \
    socat \
    breeze \
    breeze-gtk \
    qt5ct \
    qt6ct \
    nwg-look 

# socat is used to read hyprland ipc socket

cd ~/.dotfiles
stow quickshell
# for all files in quickshell/.local/bin, chmod +x it
for script in ./quickshell/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
