#!/bin/bash

echo ====================================================
echo ==== Artix Linux Install Script by ZestyNotions ====
echo ====================================================
echo ""
echo ""
echo The script will assume you have your boot and root disk mounted and formatted...
echo ================================================================================
sleep 1
echo ""
echo will quickly check your network connection ...
echo ===========================================================
ping -c1 google.com && startinstall=y || echo Failure!
echo ""
export startinstall

# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then
echo Now basestrapping the system ...
sudo basestrap /mnt base base-devel runit elogind-runit linux linux-firmware glibc nano
echo ===========================================================
sleep 1

echo Now Generating the fstab file for mountpoints ...
echo ===========================================================
sleep 1
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
sleep 1
ip link
echo ""
echo Add the name of your network adaptor e.g. "enp0s3" for virtualbox machines.
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
sleep 2
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
