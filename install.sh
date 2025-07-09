chmod +x ./generate-stow-local-ignore.sh

for package_dir in */; do
	if [ -f "$package_dir/install.sh" ]; then
		chmod +x "$package_dir/install.sh"
		echo "Running install script for $package_dir"
		(cd "$package_dir" && ./install.sh)
	fi
done
