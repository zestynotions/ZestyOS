#!/bin/bash

echo ====================================================
echo ==== Artix Linux Install Script by ZestyNotions ====
echo ====================================================
sleep 3
echo ""
echo ""
if [ "$(id -u)" = 0 ]; then
    echo "##################################################################"
    echo "This script MUST NOT be run as root user since it makes changes"
    echo "to the \$HOME directory of the \$USER executing this script."
    echo "The \$HOME directory of the root user is, of course, '/root'."
    echo "We don't want to mess around in there. So run this script as a"
    echo "normal user. You will be asked for a sudo password when necessary."
    echo "##################################################################"
    exit 1
fi

echo ""
echo will quickly check your network connection ...
echo ===========================================================
ping -c1 google.com && startinstall=y || echo Failure!
echo ""

echo The script will partition you /dev/sda drive and format it !WARNING! all will be lost so you better be sure before continuing. You have been warned!...
echo ================================================================================
sleep 5 

export startinstall

# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then

  # Partitioning of the /dev/sda drive

  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +300M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Formatting the new partiotions
sudo mkfs.fat -F 32 /dev/sda1
sudo fatlabel /dev/sda1 BOOT
sudo mkfs.f2fs -l ROOT /dev/sda2 
sudo mount /dev/sda2 /mnt
sudo mkdir /mnt/boot
sudo mount /dev/sda1 /mnt/boot

echo Now basestrapping the system ...
sleep 2 
sudo basestrap /mnt base base-devel runit elogind-runit linux linux-firmware glibc nano
echo ===========================================================
sleep 1

echo Now Generating the fstab file for mountpoints ...
echo ===========================================================
sleep 3
# generate fstab for filesystem mounts
sudo touch /mnt/etc/fstab
sudo chmod 777 /mnt/etc/fstab
sudo fstabgen -U /mnt >> /mnt/etc/fstab

echo Copying the install script to the new root environtment ... 
echo ===========================================================
sleep 1
# bring install file to new env
sudo curl -LO zestynotions.com/zns/artix_base_install_final.sh
sudo chmod 777 artix_base_install_final.sh
sudo mv artix_base_install_final /mnt
echo ""

clear

# prep rc.local to set static IP
echo Time to add a network configuration, we will assume dhcp but you can change the /etc/rc.local later if you want it to be static.
sleep 3
ip link
echo ""
echo Add the name of your network adaptor e.g. "enp0s3" for virtualbox machines and likely "eth0" for normal lan.
echo -e "\e[1;32m ============================================ \e[0m "
read -p 'Name of network adaptor: ' netname
echo -e "\e[1;32m ============================================ \e[0m "
sudo touch /mnt/etc/rc.local
sudo chmod 777 /mnt/etc/rc.local
sudo echo "#ip link set $netname up" >> /mnt/etc/rc.local
sudo echo "#ip addr add your_ip_here/24 brd + dev $netname" >> /mnt/etc/rc.local
sudo echo "#ip route add default via router_ip_here" >> /mnt/etc/rc.local
sudo echo "dhcpcd $netname" >> /mnt/etc/rc.local


# reminder for after chroot action
echo =============================================================================
echo -e "Type \e[1;32m sh artix_final.sh \e[0m"
echo =============================================================================
sleep 3
# change root environtment
artix-chroot /mnt

else

  echo =======================================
  echo ""
  echo No network detected so cannot continue!
  echo ""
  echo =======================================

fi
exit
