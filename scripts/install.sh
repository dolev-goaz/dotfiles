sudo pacman -S --needed \
	fzf \
	jq

yay -S --needed \
	python-pywal

# chmod +x all scripts under scripts/

for script in ./scripts/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done

cd ~/.dotfiles
stow scripts
