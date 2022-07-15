#!/bin/bash

echo "WARNING This script will install Sway tiling windows manager, brave browser and Arch user repo through"
echo "Paru and lastly neovim and will add config files for those, so you better know what you are doing!"
echo ""
sudo sv start chrony
echo Would you like to install? "(Y or N)"
read swayinstall
if [ "$swayinstall" = "y" ]; then

echo "Updating system and packages ahead of install..."
echo ""
# Update system before application install
sudo pacman -Syu --noconfirm --needed

# List apps to install
APPS="mesa ttf-fira-code imv bat ripgrep sway swaybg xorg-xwayland alacritty wl-clipboard base-devel"

# Install base applications
sudo pacman -Sq $APPS --needed --noconfirm
fi

# Cleanup install stage 2 file from root dir
sudo rm -rf /ZestyOS_stage2.sh

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
exit
