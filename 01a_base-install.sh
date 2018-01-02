#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# A script to prepare the harddisk for an archlinux installation

echo "#########################"
echo "# Pacstrap arch to disk #"
echo "#########################"
echo "#"
echo "#Pacstraping..."
pacman -Sy archlinux-keyring
pacstrap /mnt base base-devel btrfs-progs wpa_supplicant dialog intel-ucode bash-completion
