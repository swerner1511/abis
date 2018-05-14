#!/bin/bash

# Created by S. W.
# latest update 14.05.2018
#
# A script to install an AUR-Helper (trizen)
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si
