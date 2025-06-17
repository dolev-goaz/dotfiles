# uses jq, fzf
all_scripts=""
while IFS= read -r package_file; do
	pkg_name=$(jq -r '.name // empty' "$package_file") # get package name
	if [ -z "$pkg_name" ]; then
		pkg_name=$(basename "$(dirname "$package_file")") # fallback - directory name
	fi
	pkg_scripts=$(jq -r --arg pkg "$pkg_name" '.scripts // {} | keys[] | "\($pkg) - \(.)"' "$package_file")
	all_scripts+="$pkg_scripts"$'\n'
done < <(find . -type d -name node_modules -prune -o -type f -name package.json -print) # read all package.json files

if [ -z "$all_scripts" ]; then
	echo "ERROR: No package.json scripts were found."
	exit 1
fi

choice=$(printf "%s" "$all_scripts" | fzf --prompt="Select a script to run: ")

pkg_name="${choice%% - *}"   # everything before ' - '
script_name="${choice#* - }" # everything after ' - '

# TODO: handle monorepo root/lone package case
npm run --workspace="$pkg_name" "$script_name"
