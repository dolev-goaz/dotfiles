sudo pacman -S --needed \
	zsh \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
    zoxide \
    eza

yay -S --needed \
	nvm

cd ~/.dotfiles
stow zsh
