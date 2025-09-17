yay -S --needed \
	udiskie

sudo pacman -S --needed \
	ntfs-3g

cd ~/.dotfiles
stow udiskie

# NODE: need to install polkit. sudo pacman -S polkit
# NOTE: need /etc/polkit-1/rules.d/50-udisks2-mount.rules to have-
# polkit.addRule(function(action, subject) {
#     if (
#         (action.id.indexOf("org.freedesktop.udisks2.") == 0) &&
#         subject.isInGroup("wheel")
#     ) {
#         return polkit.Result.YES;
#     }
# });
