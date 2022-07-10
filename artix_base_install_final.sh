#!/bin/bash

# set region
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# set time
hwclock --systohc

# generate locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen


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

# Further installs
sudo pacman -Sq dhcpcd-runit rsm htop broot figlet ttf-fira-code lolcat openssh-runit tmux zsh exa bat --needed --noconfirm

sudo echo Changing the default shell to ZSH
sudo chsh -s /bin/zsh $newuser

curl -LO zestynotions.com/zns/.zshrc
curl -LO zestynotions.com/zns/.tmux.conf
sudo chmod 777 .zshrc .tmux.conf
sudo chown $newuser .*
sudo cp .zshrc .tmux.conf /home/$newuser/ 



clear
echo ""
echo -e "\e[1;32m ============================================ \e[0m "
echo Would you like to also install Sway Wayland tiling windows manager? "(Y or N)"
echo -e "\e[1;32m ============================================ \e[0m "

read startinstall
# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then

  curl -LO zestynotions.com/zns/sway_install.sh
  sudo chmod 777 sway_install.sh
  sudo cp sway_install.sh /home/$newuser/
  echo Remember to run the 'sway_install.sh' after reboot and login to your new user account $newuser
  sleep 3

fi

# # prep rc.local to set static IP
# echo Time to add a network configuration, we will assume dhcp but you can change the /etc/rc.local later if you want it to be static.
# sleep 1
# ip link
# echo ""
# echo Add the name of your network adaptor e.g. "enp0s3" for virtualbox machines.
# echo -e "\e[1;32m ============================================ \e[0m "
# read -p 'Name of network adaptor: ' netname
# echo -e "\e[1;32m ============================================ \e[0m "
# sudo chmod 777 /etc/rc.local
# sudo echo "#ip link set $netname up" >> /etc/rc.local
# sudo echo "#ip addr add your_ip_here/24 brd + dev $netname" >> /etc/rc.local
# sudo echo "#ip route add default via router_ip_here" >> /etc/rc.local
# sudo echo "dhcpcd $netname" >> /etc/rc.local
 
echo ==========================================================================
echo -e "Done! Type: \e[1;32m sudo umount -R /mnt and sudo reboot.\e[0m"
echo Remember to run 'sudo rsm and disable/enable service needed after reboot'.
echo ==========================================================================

