#!/bin/bash

# Listen specifically for interface (link) changes
ip monitor link | while read -r line; do
    if echo "$line" | grep -q "tun0"; then
        if echo "$line" | grep -q "LOWER_UP"; then
            echo "connected"
        else
            echo "disconnected"
        fi
    fi
done
