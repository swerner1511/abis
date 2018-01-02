#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# A script to prepare the harddisk for an archlinux installation
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
