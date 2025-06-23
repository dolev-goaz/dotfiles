#!/bin/bash

# Get mute state of the default sink
MUTE_STATE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Toggle mute
if [ "$MUTE_STATE" = "yes" ]; then
	pactl set-sink-mute @DEFAULT_SINK@ 0
else
	pactl set-sink-mute @DEFAULT_SINK@ 1
fi
