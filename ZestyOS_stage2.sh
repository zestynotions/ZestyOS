#!/bin/bash

# set region
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# set time
hwclock --systohc

echo "Setting console keyboard layout"
sudo echo "KEYMAP=us" > /etc/vconsole.conf 
 
# generate locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# enable parallel downloads in pacman to substansially speed up installs
sudo sed -i -e 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf

# install bootloader
pacman -Sq grub os-prober efibootmgr --needed --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

clear
# change root password
echo -e "\e[1;32m ============================================ \e[0m "
echo Let us first change the root password!
echo -e "\e[1;32m ============================================ \e[0m "
passwd
clear

# add user
echo Okay time to add a new user that will have sudo priviledge.
echo Add name of the user you want to add:
echo -e "\e[1;32m ============================================ \e[0m "
read -p 'Adding new user: ' newuser
echo -e "\e[1;32m ============================================ \e[0m "
useradd -mG wheel $newuser
passwd $newuser
sleep 1
echo User $newuser added successfully!.
sleep 1
clear
# create hostname
echo Please input a hostname for this machine:
echo -e "\e[1;32m ============================================ \e[0m "
read -p 'Set the Hostname: ' mname
echo -e "\e[1;32m ============================================ \e[0m "
touch /etc/hostname
sudo echo $mname > /etc/hostname


# populate hosts file
echo adding the hostname to the hosts file
sudo echo "127.0.0.1 localhost" > /etc/hosts
sudo echo "::1 localhost" >> /etc/hosts
sudo echo "127.0.0.1 $mname.local $mname" >> /etc/hosts


# add Wheel to sudo file
sudo echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers


# Further installs - services
sudo pacman -Sq rsm cronie-runit chrony-runit dhcpcd-runit openssh-runit --needed --noconfirm
sudo mkdir /run/runit/service
sudo ln -s /etc/runit/sv/chrony /run/runit/service/
sudo sv start chrony


# add .config files
git clone -depth=1 https://github.com/zestynotions/dotfiles.git
sudo chmod -R +x ~/dotfiles/*
cp -rf ~/dotfiles/.config ~/
cp -rf ~/dotfiles/.zshrc ~/
cp -rf ~/dotfiles/.zshenv ~/
sudo rm -rf ~/dotfiles


# Further installs - apps
sudo pacman -Sq git neovim tmux zsh figlet noto-fonts ttf-fira-code --needed --noconfirm

# change the default shell for user
sudo echo Changing the default shell to ZSH
sudo chsh -s /bin/zsh $newuser

echo -e "\e[1;32m ==================================================================== \e[0m "
echo Would you like to also install Sway Wayland tiling windows manager? "(Y or N)"
echo -e "\e[1;32m ==================================================================== \e[0m "

read startinstall
# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then

  curl -LO https://github.com/zestynotions/ZestyOS/raw/main/sway_install.sh
  sudo chmod 777 sway_install.sh
  sudo cp sway_install.sh /home/$newuser/
fi

echo ==========================================================================
echo -e "Done! Please Type: \e[1;32m 'exit' and then 'sudo reboot' \e[0m"
echo ==========================================================================

