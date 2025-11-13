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

function get_battery_info {
	local status=$(cat "$STATUS_FILE")
	local capacity=$(cat "$CAPACITY_FILE")

	echo "$status, $capacity"
}

while true; do
	get_battery_info
	sleep 1
done
