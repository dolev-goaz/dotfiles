threshhold_ok=0
threshhold_warn=25
threshhold_crit=100

updates=$(~/scripts/available-updates-arch.sh)

official=$(echo "$updates" | jq .official)
aur=$(echo "$updates" | jq .aur)
total=$(echo "$updates" | jq .total)

css_class="ok"
if [ "$total" -ge "$threshhold_crit" ]; then
	css_class="critical"
elif [ "$total" -ge "$threshhold_warn" ]; then
	css_class="warning"
else
	css_class="ok"
fi

printf '{"text": "%s", "alt": "%s", "tooltip": "%s updates. %s from pacman. %s from AUR", "class": "%s"}' "$total" "$total" "$total" "$official" "$aur" "$css_class"
