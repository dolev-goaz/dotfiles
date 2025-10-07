for dir in */; do
	file="$dir/.stow-local-ignore"
	if [ -f "$file" ]; then
		continue
	fi

	echo "\.gitignore" >"$file"
	echo "install.sh" >>"$file"
done
