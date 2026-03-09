if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
else
    bun upgrade
fi

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
