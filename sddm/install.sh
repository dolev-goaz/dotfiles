sudo pacman -S --needed \
	qt6-svg \
	qt6-declarative \
	qt5-quickcontrols2

chmod o+x /home/dolev
chmod o+x /home/dolev/.dotfiles
chmod o+x /home/dolev/.dotfiles/sddm
chmod o+r /home/dolev/.dotfiles/sddm/etc/sddm.conf
chmod o+r /home/dolev/.dotfiles/sddm/etc/X11
chmod o+r /home/dolev/.dotfiles/sddm/etc/X11/xorg.conf.d
chmod o+r /home/dolev/.dotfiles/sddm/etc/X11/xorg.conf.d/20-touchpad.conf

chmod o+x /home/dolev/.dotfiles/sddm/usr
chmod o+x /home/dolev/.dotfiles/sddm/usr/share
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm/themes
chmod o+x /home/dolev/.dotfiles/sddm/usr/share/sddm/themes/catppuccin-mocha
chmod -R o+r /home/dolev/.dotfiles/sddm/usr/share/sddm/themes/catppuccin-mocha

cd ~/.dotfiles
sudo stow -t / sddm
