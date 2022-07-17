#!/bin/sh
echo ""
echo "Welcome to ZestyOS installer"
echo ""
ping -c3 google.com
wget https://raw.githubusercontent.com/zestynotions/ZestyOS/main/alpine_setup_file
setup-alpine -f alpine_setup_file
reboot
