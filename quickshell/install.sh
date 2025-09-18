yay -S --needed \
	quickshell

cd ~/.dotfiles
stow quickshell
# for all files in quickshell/.local/bin, chmod +x it
for script in ./quickshell/.local/bin/*; do
	if [[ -f "$script" ]]; then
		chmod +x "$script"
	fi
done
