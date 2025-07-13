sudo pacman -S --needed \
	fzf \
	jq

# chmod +x all scripts under scripts/

for script in ./scripts/*; do
    if [[ -f "$script" ]]; then
        chmod +x "$script"
    fi
done
