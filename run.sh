#!/bin/sh
echo ""
echo "===================================="
echo "=== Welcome to ZestyOS installer ==="
echo "===================================="
echo ""
ping -c1 google.com
wget https://raw.githubusercontent.com/zestynotions/ZestyOS/main/alpine_setup_file
setup-alpine -f alpine_setup_file

mkdir /home/zns
cd /home/zns
wget https://raw.githubusercontent.com/zestynotions/ZestyOS/main/runme.sh
chmod +x runme.sh


echo "==============================="

echo "Reboting in ..3 sec" 
sleep 1
echo "Reboting in ..2 sec" 
sleep 1
echo "Reboting in ..1 sec" 
sleep 1
reboot
