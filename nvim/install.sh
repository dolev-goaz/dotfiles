sudo pacman -S --needed \
	neovim \
	ripgrep \
	tree-sitter-cli

cd ~/.dotfiles
stow nvim
