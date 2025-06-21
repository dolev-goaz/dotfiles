official_updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qum 2>/dev/null | wc -l)
total_updates=$((official_updates + aur_updates))

echo "{\"official\":$official_updates,\"aur\":$aur_updates,\"total\":$total_updates}"
