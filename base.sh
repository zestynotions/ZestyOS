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

echo The script will partition you /dev/sda drive and format it 
echo !WARNING! all will be lost so you better be sure before continuing...
echo ================================================================================
sleep 5 

export startinstall

# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then

  # Partitioning of the /dev/sda drive

  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk /dev/sda
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

echo Now Generating the fstab file for mountpoints ...
echo ===========================================================
sleep 3
# generate fstab for filesystem mounts
sudo touch /mnt/etc/fstab
sudo chmod 777 /mnt/etc/fstab
sudo fstabgen -U /mnt >> /mnt/etc/fstab


else

  echo =======================================
  echo ""
  echo No network detected so cannot continue!
  echo ""
  echo =======================================

fi
exit
