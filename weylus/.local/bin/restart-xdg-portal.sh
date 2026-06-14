systemctl --user kill -s SIGKILL xdg-desktop-portal-hyprland.service xdg-desktop-portal.service
sleep 1
systemctl --user start xdg-desktop-portal
