if [ "$(uname)" = "Darwin" ]; then
	brew install --cask nikitabobko/tap/aerospace
fi

cd ~/.dotfiles
stow aerospace
