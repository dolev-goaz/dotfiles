#!/bin/bash
swww img "$1" --transition-type grow --transition-duration 1.0 --transition-fps 120

# create a blurred version of the wallpaper for hyprlock
magick "$1" -blur 0x8 ~/Pictures/Wallpapers/active-blurred.png

# store the blurred wallpaper in the sddm theme folder
cp ~/Pictures/Wallpapers/active-blurred.png /usr/share/sddm/themes/catppuccin-mocha/backgrounds/active-blurred.png
sync # ensure the file is written before locking
