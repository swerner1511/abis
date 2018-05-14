#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# A script to prepare the harddisk for an archlinux installation

echo "#"
echo "############################"
echo "# Mirrorlist Configuration #"
echo "############################"
echo "#"
echo "#install reflector..."
pacman -S --needed --noconfirm reflector
echo "#"
echo "#Update mirror list..."
reflector --verbose -l 5 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu
echo "#"
echo "################"
echo "# Set Hostname #"
echo "################"
echo "#"
echo "#Enter your Hostname..."
read HOSTNAME
echo "$HOSTNAME" > /etc/hostname
echo "#"
echo "#################"
echo "# Set Time zone #"
echo "#################"
echo "#setting Time Zone..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "#"
echo "#####################"
echo "# Locale Generating #"
echo "#####################"
echo "#generate locales..."
sed -ie 's/#de_DE/de_DE/g' /etc/locale.gen
#sed -ie 's/#en_US/en_US/g' /etc/locale.gen
locale-gen
echo "#"
echo "#######################"
echo "# Set default locales #"
echo "#######################"
echo "#setting default locales..."
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "LANGUAGE=de_DE" >> /etc/locale.conf
echo "#"
echo "######################"
echo "# Set console keymap #"
echo "######################"
echo "#setting console keymap..."
echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf
echo "#"
echo "#########################"
echo "# Set Hooks for ramdisk #"
echo "#########################"
echo "#Add scripts to ramdisk..."
sed -i '/^HOOK/s/block/block keymap encrypt/' /etc/mkinitcpio.conf
sed -i '/^HOOK/s/filesystems/lvm2 filesystems/' /etc/mkinitcpio.conf
echo "#"
echo "###################"
echo "# Refresh ramdisk #"
echo "###################"
echo "#Regenerate ramdisk..."
mkinitcpio -p linux
echo "#"
echo "###########################"
echo "# Grub install and config #"
echo "###########################"
echo "#Install Grub..."
pacman -S --needed --noconfirm grub
echo "#"
echo "#Configuring Grub..."
sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/s/quiet/cryptdevice=\/dev\/sda2:crypt0/' /etc/default/grub
echo "#"
echo "#Install grub to disk..."
grub-install /dev/sda
echo "#"
echo "#Generate Grub config..."
grub-mkconfig -o /boot/grub/grub.cfg
echo "#"
echo "##################"
echo "# xorg server... #"
echo "##################"
pacman -S --needed --noconfirm xorg-server xorg-xinit
localectl --no-convert set-x11-keymap de pc105 nodeadkeys
echo "#"
echo "######################"
echo "# some basic pkgs... #"
echo "######################"
pacman -S --needed --noconfirm acpid avahi cups cronie firefox firefox-i18n-de thunderbird thunderbird-i18n-de
systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable cronie
systemctl enable org.cups.cupsd.service
ntpdate -u 0.de.pool.ntp.org
hwclock -w
echo "#"
echo "#######################"
echo "# graphical driver... #"
echo "#######################"
pacman -S --needed --noconfirm xf86-video-intel
#DE install script
sh ./02_de-install.sh
echo "#"
echo "#################"
echo "# aur-helper... #"
echo "#################"
pacman -S --needed --noconfirm git
#aur-helper install script
sh ./03_aurhelper.sh
echo "#"
echo "###########################"
echo "# create useraccount... #"
echo "###########################"
echo "Enter your username..."
read USERNAME
useradd -m -g users -G wheel,audio,video -s /bin/bash $USERNAME
passwd $USERNAME
echo "User created..."
echo "Don't forget to EDITOR=nano visudo..."
echo "Press any key..."
read
EDITOR=nano visudo
echo ""
echo "###########################"
echo "# set root password... #"
echo "###########################"
passwd
echo "#"
echo "#Exit from chroot environment..."
exit
