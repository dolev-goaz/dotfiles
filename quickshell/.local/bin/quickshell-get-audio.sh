#!/bin/bash

# Monitor audio volume changes and output sink info
# Uses wpctl (wireplumber/pipewire)

get_default_sink() {
    wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep '\*' | sed 's/^.*\*[[:space:]]*[0-9]\+\.[[:space:]]*//; s/[[:space:]]*\[.*$//' | xargs
}

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_mute_status() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false"
}

# Output format: volume, muted, sink_name
output_status() {
    local volume=$(get_volume)
    local muted=$(get_mute_status)
    local sink=$(get_default_sink)
    echo "$volume, $muted, $sink"
}

# Output initial status
output_status

# Monitor for changes using pactl subscribe
pactl subscribe | while read -r line; do
    if echo "$line" | grep -q "sink\|server"; then
        output_status
    fi
done
