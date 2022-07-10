# ZestyOS
Install script for Artix linux with option to clone my .configs at the end. 
The intention is to have a minimal Artix install with Sway tiling windows manager.

#### Artix Linux is a fast arch based linux distro but without the systemd dependency
Please grab their minimal install iso from here: https://artixlinux.org/


### 2022-07-10 Pre-alpha stage

##### The script will partition you /dev/sda drive and format it !WARNING! all will be lost so you better be sure before continuing. You have been warned!...
The script also 

## Disks
sda1 disk will be partitioned and formatted for Fat32 300mb for boot
sda2 disk will be partitioned and formatted as f2fs (Good for NVME drives) remaining space as ROOT

## Locales
English US UTF-8 and Japanese JP UTF-8 will be added as locales

## Timezone
/ Asia / Tokyo
