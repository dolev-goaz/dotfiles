if [[ "$(uname)" = "Darwin" ]]; then
	sudo pacman -S --needed \
		zsh \
		zsh-autosuggestions \
		zsh-syntax-highlighting \
		zoxide \
		eza

	yay -S --needed \
		nvm
elif [[ -f /etc/arch-release ]]; then
	brew install \
		zsh-autosuggestions \
		zsh-syntax-highlighting \
		zoxide \
		eza \
		nvm
fi

cd ~/.dotfiles
stow zsh
