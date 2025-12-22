#!/bin/bash

# Try to find and focus the AWS VPN Client window
WINDOW_PID=$(pgrep -f "AWS VPN Client")

if [ -z "$WINDOW_PID" ]; then
    # Not running, launch it
    "/opt/awsvpnclient/AWS VPN Client" &
else
    # Already running, try to focus it
    # Get all windows and find the AWS VPN Client
    WINDOW_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class == "aws-vpn-client" or .initialClass == "aws-vpn-client" or (.title | contains("AWS VPN"))) | .address' | head -1)
    
    if [ -n "$WINDOW_ADDRESS" ]; then
        # Focus the window
        hyprctl dispatch focuswindow "address:$WINDOW_ADDRESS"
    else
        # Couldn't find the window, launch it
        "/opt/awsvpnclient/AWS VPN Client" &
    fi
fi
