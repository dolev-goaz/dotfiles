SCSS=~/.config/waybar/style.scss
TMP=~/.config/waybar/style-tmp.scss
OUT=~/.config/waybar/style.css

# 1. Copy to a temporary working file
cp "$SCSS" "$TMP"

# 2. Extract @import, @keyframes and @extend temporarily
declare -A REPLACEMENTS=(
	["@import"]="__IMPORT_PLACEHOLDER__"
	["@keyframes"]="__KEYFRAMES_PLACEHOLDER__"
	["@extend"]="__EXTEND_PLACEHOLDER__"
)
for k in "${!REPLACEMENTS[@]}"; do
	sed -i -E "s/$k/${REPLACEMENTS[$k]}/g" "$TMP"
done

# 3. Replace @var with --var
sed -i -E 's/@([a-zA-Z0-9_-]+)/--PLACEHOLDER_VARIABLE_\1/g' "$TMP"

# 4. Restore placeholders
for k in "${!REPLACEMENTS[@]}"; do
	sed -i -E "s/${REPLACEMENTS[$k]}/$k/g" "$TMP"
done

sass "$TMP" "$OUT"

# 5. Replace -- with @ in the final CSS to make it GTK-compatible again
sed -i -E 's/\--PLACEHOLDER_VARIABLE_([a-zA-Z0-9_-]+)/@\1/g' "$OUT"

# 6. Clean up
rm "$TMP" "$OUT.map"
