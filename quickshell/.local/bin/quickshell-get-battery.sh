#!/bin/bash

if [ -z "$1" ]; then
	echo "Error: No battery name provided."
	echo "Usage: $0 <battery_name>"
	echo "Example: $0 BAT0"
	exit 1
fi

BATTERY_NAME=$1
BASE_PATH="/sys/class/power_supply/$BATTERY_NAME"

if [ ! -d "$BASE_PATH" ]; then
	echo "Error: Battery '$BATTERY_NAME' not found."
	echo "Check $BASE_PATH"
	exit 1
fi

STATUS_FILE="$BASE_PATH/status"
CAPACITY_FILE="$BASE_PATH/capacity"

function format_time_remaining {
	local time_info=$1
	
	# Extract decimal hours (e.g., "2.7" from "2.7 hours")
	local hours_decimal=$(echo "$time_info" | grep -oE '[0-9]+\.[0-9]+|[0-9]+' | head -1)
	
	if [ -n "$hours_decimal" ]; then
		# Convert to total minutes using awk
		local total_minutes=$(echo "$hours_decimal" | awk '{printf "%.0f", $1 * 60}')
		
		if [ -n "$total_minutes" ] && [ "$total_minutes" -gt 0 ]; then
			local hours=$((total_minutes / 60))
			local minutes=$((total_minutes % 60))
			
			if [ $hours -gt 0 ] && [ $minutes -gt 0 ]; then
				echo "${hours} hours ${minutes} minutes"
			elif [ $hours -gt 0 ]; then
				echo "${hours} hours"
			else
				echo "${minutes} minutes"
			fi
		else
			echo "$time_info"
		fi
	else
		echo "$time_info"
	fi
}

function get_battery_info {
	local status=$(cat "$STATUS_FILE")
	local capacity=$(cat "$CAPACITY_FILE")
	
	# Get time remaining using upower
	local time_info=$(upower -i /org/freedesktop/UPower/devices/battery_$BATTERY_NAME 2>/dev/null | grep "time to" | sed 's/.*time to \(empty\|full\):\s*//' | xargs)
	if [ -z "$time_info" ]; then
		time_info="Unknown"
	else
		time_info=$(format_time_remaining "$time_info")
	fi
	
	# Get power profile if available
	local power_profile=$(powerprofilesctl get 2>/dev/null)
	if [ -z "$power_profile" ]; then
		power_profile="Not Available"
	fi

	echo "$status, $capacity, $time_info, $power_profile"
}

while true; do
	get_battery_info
	sleep 5
done
