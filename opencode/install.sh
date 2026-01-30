yay -S --needed \
	opencode

sudo pacman -S --needed \
	bubblewrap

cd ~/.dotfiles
stow opencode
for script in ./opencode/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
