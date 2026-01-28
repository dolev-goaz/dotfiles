sudo pacman -S --needed \
    hypridle \
    brightnessctl

cd ~/.dotfiles
for script in ./hypridle/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
stow hypridle
