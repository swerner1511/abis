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

# Preparing the encrypted system partitions
echo "#"
echo "#Creating of the LUKS device.."
cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 10000 --use-urandom --verify-passphrase luksFormat /dev/sda2
echo "#"
echo "Opening encrypted device..."
cryptsetup luksOpen /dev/sda2 crypt0
