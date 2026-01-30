yay -S --needed \
	opencode

cd ~/.dotfiles
stow opencode
for script in ./opencode/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
