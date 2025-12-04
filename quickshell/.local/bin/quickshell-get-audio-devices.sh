#!/bin/bash

# List available audio output devices
# Format: device_id|device_name|is_default

get_audio_devices() {
    # List all sinks
    wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep -E "^[[:space:]]+[│├└*].*[0-9]+\." | while read -r line; do
        # Extract device ID and name
        local is_default="false"
        if echo "$line" | grep -q "\*"; then
            is_default="true"
            # Remove the asterisk for parsing
            line=$(echo "$line" | sed 's/\*//')
        fi
        
        # Extract device ID (number before the dot)
        local device_id=$(echo "$line" | grep -oP '[0-9]+(?=\.)' | head -1)
        # Extract device name (after the dot and number, before the bracket)
        local device_name=$(echo "$line" | sed 's/^[^0-9]*[0-9]\+\.[[:space:]]*//; s/[[:space:]]*\[.*$//' | xargs)
        
        if [ -n "$device_id" ] && [ -n "$device_name" ]; then
            echo "${device_id}|${device_name}|${is_default}"
        fi
    done
}

get_audio_devices
