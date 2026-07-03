if [[ "$(uname)" = "Darwin" ]]; then
	brew trust Felixkratz/formulae
	brew tap FelixKratz/formulae
	brew install borders
fi

cd ~/.dotfiles
stow jankyborders
