#!/bin/bash
echo ""
echo "WARNING This script will install Sway tiling windows manager, brave browser and Arch user repo through"
echo "Paru and lastly neovim and will add config files for those, so you better know what you are doing!"
echo ""
sudo ln -s /etc/runit/sv/chrony /run/runit/service/
sudo sv start chrony
echo "==============================================="
echo Would you like to install? "(Y or N)"
echo "==============================================="
read swayinstall
if [ "$swayinstall" = "y" ]; then

echo "Updating system and packages ahead of install..."
echo ""
# Update system before application install
sudo pacman -Syu --noconfirm --needed

# add .config files
git clone --depth=1 https://github.com/zestynotions/dotfiles.git
sudo chmod -R 777 ~/dotfiles/*
cp -rf ~/dotfiles/.config ~/
cp -rf ~/dotfiles/.zshrc ~/
cp -rf ~/dotfiles/.zshenv ~/
sudo rm -rf ~/dotfiles

# List apps to install
APPS="mesa sway swaybg ttf-fira-code imv bat ripgrep xorg-xwayland alacritty wl-clipboard base-devel"

# Install base applications
sudo pacman -Sq $APPS --needed --noconfirm
fi

# Install AUR to get the brave browser
echo "Installing Arch User repository and PARU frontend"
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
paru 
paru -S pfetch-btw wofi-hg brave-bin btop duf exa --noconfirm --needed

sudo rsm disable agetty-tty3
sudo rsm disable agetty-tty4
sudo rsm disable agetty-tty5
sudo rsm disable agetty-tty6
echo "-----------------------------"
# Report completion using the figlet
echo ""
figlet "Install Completed!"
echo "-----------------------------"

# Cleanup install stage 2 file from root dir
sudo rm -rf /ZestyOS_stage2.sh
sudo rm -rf sway_install.sh 

exit
