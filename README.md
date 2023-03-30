# ZestyOS

2023-03-25
### ZestyOS a.k.a "RustyAlpine"

A new year, a new distribution!
These days I'm on Alpine Linux and quite happy. It is outragiously fast and responsive and using the OpenRC init system over Systemd. Go and check it out here: [AlpineLinux.org](AlpineLinux.org)

It is also super fast to install and often the preferred OS for containers, this also means it has a few restrictions but if you change the default shell from ash to zsh and use the edge repositories you can have a really good experience. (Disclaimer: I only use it for server and no-audio desktop environtment, but I see no reason why it would not be great for any use case really)
Once the ISO boots you login with root (no password) and type: "setup-alpine" and follow the prompts.

OR you can do like me and script/use a setup file for the install.
```code
setup-alpine -f https://zns.one/alpine
```

This will install the system for you with sane defaults, and only prompt you for which hard drive to install to. 
(It will however assume you are in Asia/Tokyo timezone, and using us keyboard with dhcp for your network, but these can of course be easily changed later as needed under /etc )

Once the install finish, reboot and login with the root user and the password created during setup. Then run the following command to install a user, use edge and community repo's as well as install rust tool chain and zsh and finally it will pull my dotfiles.

```code 
sh <(wget -qO- https://zns.one/zestyos)
```


# Artix
Install script for Artix linux with option to clone my .configs at the end. 
The intention is to have a minimal Artix install with Sway tiling windows manager.

#### Artix Linux is a fast arch based linux distro without the systemd dependency
Please grab their minimal install iso from here: https://artixlinux.org/


### 2022-07-10 Alpha stage and not in active development 

##### The script will partition you /dev/sda drive and format it !WARNING! all will be lost so you better be sure before continuing. You have been warned!...
The script also 

## Disks
sda1 disk will be partitioned and formatted for Fat32 300mb for boot
sda2 disk will be partitioned and formatted as f2fs (Good for NVME drives) remaining space as ROOT

## Locales
English US UTF-8 and Japanese JP UTF-8 will be added as locales

## Timezone
/ Asia / Tokyo


*There are 3 stages of the install*
Stage 1 bootstrap and change root
This will run the "artix_base.sh" this will bootstrap the system, set locale, create an fstab file, set networking for cabled systems etc.
It will then download the stage 2 file and copy it to the new system, and finally change root into the new system and prompt to run the next stage.


So to get started, boot the artix liveimage, create and mount boot and root, and the type the following code and follow the few instruction that show up, whole stage 2 completes in like 5min. depending on download speed.
Write in prompt on Artix live systems:

bash <(curl -s https://zestynotions.com/zns/artix_base.sh)
I will make a small youtube video to show the "what and why" of the script in the near future™

*Stage 2 base install and config*
This will need to be run next and is in the root of the new invirontment. "artix_base_install_final.sh", this will install a number of other base packages like grub and set machine name and new user creation depending on your wishes. It will also download my config files for zsh shell, tmux, and more.
This environtment is great as a headless systems as it is ~22 processes and ~60mb Ram usage om boot. If a headless system is all you need, you can stop here, you are set.

*Stage 3 Desktop invirontment install*
If you are on an arch system and all you want is the Sway desktop invirontment with the newest Neovim+LunarVim, alacritty, paru, ranger etc you can just copy/pasta the below. (note: rename any existing nvim folder you might have or it will conflict)

bash <(curl -s https://zestynotions.com/zns/sway_install.sh)

