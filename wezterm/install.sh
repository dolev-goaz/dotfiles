if [[ "$(uname)" = "Darwin" ]]; then
	brew install \
		wezterm \
		font-fira-code-nerd-font
elif [[ -f /etc/arch-release ]]; then
	yay -S --needed \
		wezterm-nightly-bin

	sudo pacman -S --needed \
		ttf-firacode-nerd
fi

cd ~/.dotfiles
stow wezterm
