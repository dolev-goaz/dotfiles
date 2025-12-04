#!/bin/bash

# Set the default audio sink
# Usage: quickshell-set-audio-device.sh <device_id>

if [ -z "$1" ]; then
    echo "Usage: $0 <device_id>"
    exit 1
fi

wpctl set-default "$1"
