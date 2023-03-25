#!/bin/bash

echo "Warning ! This script will install Brew, neovim, zsh, fonts and alacritty terminal and other smaller tools as well as overwrite various configs for those systems if they already exists, so you better know what you are doing!"
echo ""
echo Would you like to install? "(Y or N)"

read startinstall
# now check if $startinstall is "y"
if [ "$startinstall" = "y" ]; then

	echo "Installing Brew and updating system and packages ahead of install..."
	echo ""

	# Install Brew and Update system before application install
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	sleep 2

	brew update

	# List apps to install
	APPS="git exa neovim bat alacritty lf btop tmux cask-fonts/font-fira-code cask-fonts/font-fira-code-nerd-font yabai skhd figlet lolcat"
	# APPS="git zsh exa bat alacritty btop tmux cask-fonts/font-fira-code cask-fonts/font-fira-mono cask-fonts/font-fira-code-nerd-font figlet lolcat"

	# Install base applications
	brew install $APPS
fi

clear
# Report completion using the figlet
figlet "Install completed!"
echo ""
echo "======================================================"
echo "All done! you can reboot the machine now - enjoy!"
echo ""
