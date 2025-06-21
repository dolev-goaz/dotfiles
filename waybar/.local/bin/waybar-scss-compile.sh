SCSS=~/.config/waybar/style.scss
TMP=~/.config/waybar/style-tmp.scss
DUMMY=~/.config/waybar/_dummy-vars.scss
OUT=~/.config/waybar/style.css

# 1. Copy to a temporary working file
cp "$SCSS" "$TMP"

# 2. Extract @import and @keyframes temporarily
sed -i -E 's/@import/__IMPORT_PLACEHOLDER__/g; s/@keyframes/__KEYFRAMES_PLACEHOLDER__/g' "$TMP"

# 3. Replace @var with --var
sed -i -E 's/@([a-zA-Z0-9_-]+)/--\1/g' "$TMP"

# 4. Restore placeholders
sed -i -E 's/__IMPORT_PLACEHOLDER__/@import/g; s/__KEYFRAMES_PLACEHOLDER__/@keyframes/g' "$TMP"

# 5. Extract all $variables and generate dummy declarations
grep -o '\$[a-zA-Z0-9_-]\+' "$TMP" | sort -u | while read -r var; do
	echo "$var: null !default;"
done >"$DUMMY"

# 6. Concatenate dummy variables + tmp.scss and compile
cat "$DUMMY" "$TMP" >"$TMP.with-vars.scss"
sass "$TMP.with-vars.scss" "$OUT"

# 7. Replace -- with @ in the final CSS to make it GTK-compatible again
sed -i -E 's/\--([a-zA-Z0-9_-]+)/@\1/g' "$OUT"

# 8. Clean up
rm "$TMP" "$TMP.with-vars.scss" "$DUMMY" "$OUT.map"
