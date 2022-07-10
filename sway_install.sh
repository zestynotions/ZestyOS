#!/bin/bash

echo "WARNING This script will install Sway tiling windows manager, brave browser and Arch user repo through"
echo "Paru and lastly neovim and will add config files for those, so you better know what you are doing!"
echo ""
echo Would you like to install? "(Y or N)"

read swayinstall
if [ "$swayinstall" = "y" ]; then

echo "Updating system and packages ahead of install..."
echo ""
# Update system before application install
sudo pacman -Syu --noconfirm --needed

# List apps to install
APPS="ttf-fira-code figlet neovim ttf-nerd-fonts-symbols imv sway xorg-xwayland alacritty xclip git base-devel wofi"


# Install base applications
sudo pacman -Sq $APPS --needed --noconfirm
fi

echo "======================================================"
echo "Downloading and adding config files..."
echo ""

# Install AUR to get the brave browser
echo Installing Arch User repository and PARU frontend
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -sic
paru 
paru -S pfetch brave-bin btop duf exa broot bat --noconfirm --needed

sudo rsm disable agetty-tty3
sudo rsm disable agetty-tty4
sudo rsm disable agetty-tty5
sudo rsm disable agetty-tty6


echo -----------------------------
# Report completion using the figlet
clear 

# Cleanup
sudo sed -i -e 's/sh ~/sway_install.sh//g' /etc/rc.local
rm -rf ~/ZestyOS_stage2.sh

echo ""
figlet "Install Completed!"
exit
