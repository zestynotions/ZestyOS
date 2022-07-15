#!/bin/bash

installingMicrocode() {
    sleep 2s
    clear
    if lscpu | grep  "GenuineIntel"; then
        echo "Installing Intel microcode"
        pacman -S --noconfirm --needed intel-ucode
    elif lscpu | grep "AuthenticAMD"; then
        echo "Installing AMD microcode"
        pacman -S --noconfirm --needed amd-ucode
    fi
}


timezone() {
    echo "Getting Timezone..."
    time_zone="$(curl --fail https://ipapi.co/timezone)"
    clear
    echo "System detected your timezone to be $time_zone"
    echo "Is this correct?"

    PS3="Select one.[1/2]: "
    options=("Yes" "No")
    select one in "${options[@]}"; do
        case $one in
            Yes)
                echo "${time_zone} set as timezone"
                ln -sf /usr/share/zoneinfo/"$time_zone" /etc/localtime && break
                ;;
            No)
                echo "Please enter your desired timezone e.g. Europe/London :"
                read -r new_timezone
                echo "${new_timezone} set as timezone"
                ln -sf /usr/share/zoneinfo/"$time_zone" /etc/localtime && break
                ;;
            *) echo "Wrong option. Try again";timezone;;
        esac
    done
}

timezone
installingMicrocode
