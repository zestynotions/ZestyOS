#!/bin/sh
echo ""
echo "===================================="
echo "=== Welcome to ZestyOS installer ==="
echo "===================================="
echo ""
ping -c1 google.com
wget https://raw.githubusercontent.com/zestynotions/ZestyOS/main/alpine_setup_file
setup-alpine -f alpine_setup_file

wget https://raw.githubusercontent.com/zestynotions/ZestyOS/main/runme.sh
chmod +x runme.sh
doas cp -rf runme.sh /home/zns 

echo "==============================="

echo "Reboting in ..3 sec" 
sleep 1
echo "Reboting in ..2 sec" 
sleep 1
echo "Reboting in ..1 sec" 
sleep 1
# reboot
