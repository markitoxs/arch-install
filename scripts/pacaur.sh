#!/usr/bin/env bash
#
echo '########### INSTALLING STUFF ############'
cd
pacaur -Sy --noedit --noconfirm vim-runtime vim-airline vim-airline-themes
pacaur -Sy --noedit --noconfirm i3-gaps i3status rxvt-unicode stow xterm rofi
pacaur -Sy --noedit --noconfirm powerline powerline-common powerline-fonts-git
pacaur -Sy --noedit --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
pacaur -Sy --noedit --noconfirm xorg-server xorg-xinit
pacaur -Sy --noedit --noconfirm firefox

# Clone repo
echo '############# Clone configs ##############'
git clone https://github.com/markitoxs/.dotfiles.git

cd .dotfiles

stow zsh
stow i3
stow xresources

# Special love
rm ~/.vim* -rf
stow vim

echo '############# Create config files ##############'
echo 'exec i3' >> /home/markitoxs/.xinitrc

echo '############# Droping into a shell: ##############'

bash
