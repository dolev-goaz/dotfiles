sudo pacman -S --needed \
	k9s

# aws- from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
cd ~
# only if aws directory does not exist
if [ ! -d "aws" ]; then
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm awscliv2.zip
fi

# aws vpn- from https://aur.archlinux.org/packages/awsvpnclient
yay -S --needed \
	awsvpnclient

sudo systemctl enable --now systemd-resolved.service # not sure if needed
sudo systemctl enable --now awsvpnclient

# kubectl
sudo pacman -S --needed \
	kubectl
