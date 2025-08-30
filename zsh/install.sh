sudo pacman -S --needed \
	zsh \
	zsh-autosuggestions \
	zsh-syntax-highlighting

yay -S --needed \
	nvm

cd ~/.dotfiles
stow zsh
