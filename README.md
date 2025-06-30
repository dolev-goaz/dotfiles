stowing sddm-
source: https://github.com/catppuccin/sddm?tab=readme-ov-file
sudo pacman -Syu qt6-svg qt6-declarative qt5-quickcontrols2
chmod o+x /home/dolev
chmod o+x /home/dolev/.dotfiles
chmod o+x /home/dolev/.dotfiles/sddm
chmod o+r /home/dolev/dotfiles/sddm/etc/sddm.conf

chmod o+x /home/dolev/.dotfiles/sddm/usr
chmod o+x /home/dolev/.dotfiles/sddm/usr/share
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm/themes
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm/themes/catppuccin-mocha
chmod -R o+r /home/dolev/.dotfiles/sddm/usr/share/sddm/themes/catppuccin-mocha

sudo stow -t / sddm

unstowin sddm-
sudo stow -D -t / sddm
