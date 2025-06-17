# uses jq, fzf

is_package_in_workspaces() {
	pkg_json_path="$1"
	root_package_json="$2"

	pkg_dir=$(dirname "$pkg_json_path")
	root_dir=$(dirname "$root_package_json")

	workspaces=$(jq -r '
    if .workspaces? then
      if (.workspaces | type == "array") then .workspaces[]
      elif (.workspaces | type == "object") then .workspaces.packages[]
      else empty
      end
    else empty
    end
  ' "$root_package_json")

	for pattern in $workspaces; do
		for matched in "$root_dir"/$pattern; do
			[ "$(realpath "$matched")" = "$pkg_dir" ] && return 0
		done
	done

	return 1
}

find_monorepo_root_relative_to() {
	pkg_path=$(realpath "$1")
	start_dir=$(dirname "$pkg_path")
	dir=$(dirname "$start_dir")

	while [ "$dir" != "/" ]; do
		if [ -f "$dir/package.json" ] && is_package_in_workspaces "$pkg_path" "$dir/package.json"; then
			echo "$dir/package.json"
			return 0
		fi
		dir=$(dirname "$dir")
	done

	# no other root package.json
	return 0
}
all_scripts=""

# Get all package.json files under the current directory, ordered by their depth
# (Ordered so that the root package.json will be shown first)
package_files=$(find . -type f -name package.json -not -path "*/node_modules/*" |
	awk '{ print gsub(/\//,"/"), $0 }' | sort -n | cut -d' ' -f2-)

# Extract scripts from each package.json file
while IFS= read -r package_file; do
	pkg_name=$(jq -r '.name // empty' "$package_file") # get package name
	if [ -z "$pkg_name" ]; then
		pkg_name=$(basename "$(dirname "$package_file")") # fallback - directory name
	fi
	pkg_scripts=$(jq -r --arg pkg "$pkg_name" --arg fpath "$package_file" '.scripts // {} | keys[] | "\($pkg) - \(.)\t\($fpath)"' "$package_file")
	all_scripts+="$pkg_scripts"$'\n'
done <<<"$package_files"

if [ -z "$all_scripts" ]; then
	echo "ERROR: No package.json scripts were found."
	exit 1
fi

choice=$(printf "%s" "$all_scripts" | fzf --prompt="Select a script to run: " --delimiter='\t' --with-nth=1 --no-sort)
if [ -z "$choice" ]; then
	echo "ERROR: No script selected."
	exit 1
fi

pkg_info="${choice%%$'\t'*}"     # before tab(delimiter)
pkg_json_path="${choice#*$'\t'}" # after tab (delimiter)

pkg_name="${pkg_info%% - *}"   # before first dash
script_name="${pkg_info#* - }" # after first dash

root_package_json=$(find_monorepo_root_relative_to "$pkg_json_path")
if [ -z "$root_package_json" ]; then
	echo "Running script from path '$pkg_json_path' in package '$pkg_name': $script_name"
	cd "$(dirname "$pkg_json_path")"
	npm run "$script_name"
	cd -
	exit 0
fi

echo "Running script from monorepo root '$root_package_json' in package '$pkg_name': $script_name"
cd "$(dirname "$root_package_json")"
npm run --workspace="$pkg_name" "$script_name"
cd -
exit 0
