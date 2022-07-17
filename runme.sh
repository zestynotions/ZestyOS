#!/bin/sh

cd ~/
# adding Japan specific fast repos. do "setup-apkrepos" to change this later
echo "http://ftp.udx.iscoe.jp/Linux/alpine/edge/main" > /etc/apk/repositories
echo "http://ftp.udx.iscoe.jp/Linux/alpine/edge/community" >> /etc/apk/repositories

doas apk -U upgrade
doas apk add git curl g++ zsh bat exa ttf-dejavu htop btop neovim ripgrep broot tmux seatd eudev mesa-dri-gallium

doas setup-udev
doas rc-update add seatd
doas rc-service seatd start
doas adduser $USER seat

doas apk add sway
mkdir ~/.run
doas apk add xwayland foot wofi swaybg alacritty font-fira-mono-nerd font-fira-code-nerd


git clone --depth=1 https://github.com/zestynotions/dotfiles.git
chmod -R 777 * ~/dotfiles
cp ~/dotfiles/.config ~/
cp ~/dotfiles/.zshrc ~/
cp ~/dotfiles/.zshenv ~/

rm -rf ~/dotfiles
rm -rf runme.sh

doas reboot



