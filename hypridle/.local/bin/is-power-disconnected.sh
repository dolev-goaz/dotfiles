if [ $(cat /sys/class/power_supply/ADP0/online) -eq 0 ]; then
    # no power, running on battery
    exit 0
else
    exit 1
fi
