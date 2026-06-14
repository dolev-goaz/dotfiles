yay -S --needed \
	weylus-community-bin

sudo pacman -S --needed \
	gst-plugin-pipewire \
	gst-plugins-good \
	gst-plugins-bad \
	gst-plugins-ugly

cd ~/.dotfiles
for script in ./weylus/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
stow weylus
