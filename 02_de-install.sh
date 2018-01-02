#!/bin/bash

# Created by S. W.
# latest update 02.01.2018
#
# Destop Enviroment installation (Gnome)

echo "###################"
echo "# gnome+extras... #"
echo "###################"
pacman -S --needed --noconfirm gnome gnome-extra
systemctl enable gdm.service
systemctl enable NetworkManager.service
pacman -S --needed --noconfirm system-config-printer
echo "#"
echo "###########################"
echo "# remove unwanted pkgs... #"
echo "###########################"
pacman -R --noconfirm baobab empathy epiphany totem accerciser aisleriot anjuta atomix five-or-more four-in-a-row gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-music gnome-nibbles gnome-robots gnome-sudoku gnome-taquin gnome-tetravex hitori iagno lightsoff orca quadrapassel swell-foop tali
