#!/usr/bin/env bash

function get_volume() {
	pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -1 | tr -d '%'
}

function get_mute() {
	pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

latest_volume=$(get_volume)
latest_mute=$(get_mute)

function get_volume_icon() {
	local volume="${1:-$latest_volume}"
	if [ "$volume" -ge "67" ]; then
		echo "audio-volume-high"
	elif [ "$volume" -ge "34" ]; then
		echo "audio-volume-medium"
	elif [ "$volume" -ge "1" ]; then
		echo "audio-volume-low"
	else
		echo "audio-volume-muted"
	fi
}

function notify_volume() {
	# default to latest
	local volume="${1:-$latest_volume}"
	notify-send -e -a volume-osd \
		-h string:x-canonical-private-synchronous:audio-osd \
		-h int:value:$volume \
		-h string:category:volume \
		-u low \
		-i "$(get_volume_icon "$volume")" \
		"Volume" \
		"$volume%"
}

function notify_mute() {
	local mute="${1:-$latest_mute}"
	if [ "$mute" = "no" ]; then
		notify_volume "$latest_volume"
		return
	fi
	notify-send -e -a volume-osd \
		-h string:x-canonical-private-synchronous:audio-osd \
		-h string:category:volume \
		-h int:value:0 \
		-u low \
		-i "audio-volume-muted" \
		"Volume" \
		"Muted"
}

pactl subscribe | grep --line-buffered "Event 'change' on sink" | while read -r line; do
	volume=$(get_volume)
	if [ "$volume" != "$latest_volume" ]; then
		latest_volume=$volume
		notify_volume "$volume"
		continue
	fi
	mute=$(get_mute)
	if [ "$mute" != "$latest_mute" ]; then
		latest_mute=$mute
		notify_mute "$mute"
	fi
done
