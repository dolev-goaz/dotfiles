echo "==> Upgrading official packages..."
sudo pacman -Syu --noconfirm

echo "==> Upgrading AUR packages..."
yay -Sua --noconfirm

# echo "==> Updating package databases..."
# sleep 1
#
# echo "==> Upgrading official packages..."
# sleep 1
#
# echo "==> Upgrading AUR packages..."
# sleep 1
#
echo "==> Update complete."
