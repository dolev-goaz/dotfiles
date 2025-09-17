#!/bin/bash

wallpaper_path="$1"
if [ -z "$wallpaper_path" ]; then
	wallpaper_path="$HOME/Pictures/Wallpapers/.active.png"
fi

# https://github.com/dylanaraps/pywal/wiki/Getting-Started
wal -i "$wallpaper_path" -s -t -n
