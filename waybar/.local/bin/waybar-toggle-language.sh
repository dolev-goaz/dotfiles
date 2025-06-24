keyboard=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .name')

echo "$keyboard"
hyprctl switchxkblayout "$keyboard" next
