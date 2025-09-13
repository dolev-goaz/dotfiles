#!/bin/bash
swww img "$1" --transition-type grow --transition-duration 1.0 --transition-fps 120

# create a blurred version of the wallpaper for hyprlock
magick "$1" -blur 0x8 ~/Pictures/Wallpapers/active-blurred.png

# TODO: handle sddm
