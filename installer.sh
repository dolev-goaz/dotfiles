chmod +x ./generate-stow-local-ignore.sh

sudo pacman -S --needed \
	stow \
    fzf \
    git

clear

packages=()

for package_dir in */; do
	package_name="${package_dir%/}"
	packages+=("$package_name")
done

selected=$(
	printf \
		"%s\n" "${packages[@]}" |
		fzf --multi --reverse --prompt="Select packages(space to select, ctrl-a to select all): " \
			--bind "space:toggle" --bind "ctrl-space:toggle" \
			--bind "ctrl-a:toggle-all"
)

for package in $selected; do
	chmod +x "$package/install.sh"
	echo "==> Running install script for $package"
	(cd "$package" && ./install.sh)
done
