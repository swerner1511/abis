#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# A script to prepare the harddisk for an archlinux installation

# Loading default keymap for Arch live system
loadkeys de-latin1-nodeadkeys

##1# Preparing the hard disk
echo "###########################"
echo "# Preparing the hard disk #"
echo "###########################"
echo "#"
echo "#Creating the partition layout..."
parted --script /dev/sda \
    mklabel msdos \
    mkpart primary 1MB 513MB \
    set 1 boot on \
    mkpart primary 513MB 100% \
    quit

# Preparing the encrypted partition LUKS
echo "#"
echo "#Creating of the LUKS device.."
cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 10000 --use-urandom --verify-passphrase luksFormat /dev/sda2
echo "#"
echo "Opening encrypted device..."
cryptsetup luksOpen /dev/sda2 crypt0

#lvm volumes
pvcreate /dev/mapper/crypt0
vgcreate vg0 /dev/mapper/crypt0
lvcreate -L 8GiB -n swap vg0
lvcreate -l 100%FREE -n root vg0

#mkfs formate partitions
mkfs.ext4 -L BOOT /dev/sda1
mkfs.btrfs -L ROOT /dev/mapper/vg0-root
mkswap -L SWAP /dev/mapper/vg0-swap

#safty check
mkfs.btrfs -f -L ROOT /dev/mapper/vg0-root

#mount
mount /dev/mapper/vg0-root /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots
umount /mnt
mount -o noatime,ssd,space_cache=v2,compress=lzo,subvol=@ /dev/mapper/vg0-root /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home
mkdir -p /mnt/var/cache/pacman/pkg
mkdir -p /mnt.snapshots
mkdir -p /mnt/btrfs
mount -o noatime,ssd,space_cache=v2,compress=lzo,subvol=@home /dev/mapper/vg0-root /mnt/home
mount -o noatime,ssd,space_cache=v2,compress=lzo,subvol=@pkg /dev/mapper/vg0-root /mnt/var/cache/pacman/pkg/
mount -o noatime,ssd,space_cache=v2,compress=lzo,subvol=@snapshots /dev/mapper/vg0-root /mnt/.snapshots
mount -o noatime,ssd,space_cache=v2,compress=lzo,subvolid=5 /dev/mapper/vg0-root /mnt/btrfs
mount /dev/sda1
swapon /dev/mapper/vg0-swap
