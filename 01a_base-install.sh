#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# A script to install archlinux via pacstrap to the harddisk

echo "#########################"
echo "# Pacstrap arch to disk #"
echo "#########################"
echo "#"
echo "#Pacstraping..."
pacman -Sy archlinux-keyring
pacstrap /mnt base base-devel btrfs-progs wpa_supplicant dialog intel-ucode bash-completion

echo "#"
echo "#########"
echo "# fstab #"
echo "#########"
echo "#"
echo "#Generate fstab..."
genfstab -Lp /mnt >> /mnt/etc/fstab

echo "###########################"
echo "# Downloading Second Part #"
echo "###########################"
echo "#"
echo "#Download second part to set variable etc in archroot..."
#download the second script for chroot part
wget https://raw.githubusercontent.com/swerner1511/abis/master/01b_base-install.sh
#copy second script to /mnt 
cp 01b_base-install.sh /mnt
echo "#Download script to install DE (Gnome)..."
wget https://raw.githubusercontent.com/swerner1511/abis/master/02_de-install.sh
#copy de-install script to /mnt
cp 02_de-install.sh /mnt

echo "#"
echo "########################"
echo "# Starting Second Part #"
echo "########################"
echo "#Chroot into the new install..."
arch-chroot /mnt su -c "sh 01b_base-install.sh"

#### Waiting for finishing chroot session

## Clean up, unmount all and reboot
rm /mnt/01b_base-install.sh
rm /mnt/02_de-install.sh
echo "#"
echo "#Unmounting all partitions..."
umount -R /mnt
echo "#"
echo "#Deactivating swap..."
swapoff -a
echo "#"
echo "Deactivating volume group..."
vgchange -an
echo "#"
echo "#Closing Luks device..."
cryptsetup luksClose crypt0
echo "#"
echo "#Reboot and remove media ..."
echo "Press any key to reboot..."
read
reboot
