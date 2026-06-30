if [[ "$(uname)" = "Darwin" ]]; then
	brew install \
		neovim \
		ripgrep \
		tree-sitter-cli
elif [[ -f /etc/arch-release ]]; then
	sudo pacman -S --needed \
		neovim \
		ripgrep \
		tree-sitter-cli
fi

cd ~/.dotfiles
stow nvim
