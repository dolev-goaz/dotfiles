#!/bin/bash
~/scripts/extract-wallpaper-colors.sh "$1" &
awww img "$1" --transition-type grow --transition-duration 1.0 --transition-fps 120

# Get the file extension to determine format
ext="${1##*.}"

# Copy the original file preserving format (supports animated formats)
cp "$1" ~/Pictures/Wallpapers/.active."$ext"

# Create a blurred version in original format
magick "$1" -blur 0x8 ~/Pictures/Wallpapers/.active-blurred."$ext"

# Also create PNG versions for compatibility with hyprlock/sddm
magick "$1[0]" ~/Pictures/Wallpapers/.active.png
magick "$1[0]" -blur 0x8 ~/Pictures/Wallpapers/.active-blurred.png

# Update SDDM background
if [ -d /usr/share/sddm/themes/catppuccin-mocha/backgrounds ]; then
	cp ~/Pictures/Wallpapers/.active-blurred.png /usr/share/sddm/themes/catppuccin-mocha/backgrounds/active-blurred.png
	sync # ensure the file is written before locking
fi
