sudo pacman -S --needed \
	btop

cd ~/.dotfiles
stow btop

# copy theme from catppuccin repo
TMPDIR=$(mktemp -d)
trap 'rm -rf -- "$TMPDIR"' EXIT # clean up temp dir on exit
git clone https://github.com/catppuccin/btop "$TMPDIR/repo"
cp "$TMPDIR/repo/themes/catppuccin_mocha.theme" ~/.config/btop/themes/catppuccin_mocha.theme

# set theme in btop config
THEME_PATH="$HOME/.config/btop/themes/catppuccin_mocha.theme"
sed -i "s|^color_theme\s*=.*|color_theme = \"$THEME_PATH\"|" ~/.config/btop/btop.conf
