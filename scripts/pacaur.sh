#!/usr/bin/env bash
#
echo '########### INSTALLING STUFF ############'
pacaur -Sy --noedit --noconfirm i3-gaps rxvt-unicode stow
pacaur -Sy --noedit --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
pacaur -Sy --noedit --noconfirm xorg-server xorg-xinit
echo '############# Create config files ##############'
echo 'exec i3' >> /home/markitoxs/.xinitrc
bash

pacaur -Syu
