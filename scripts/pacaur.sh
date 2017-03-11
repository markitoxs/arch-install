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

# Special love for vim
rm ~/.vim* -rf
stow vim

echo '############# Create config files ##############'
echo 'exec i3' >> /home/markitoxs/.xinitrc

# Go back $HOME
cd ~
mkdir src
# to maintain compatibility
ln -s src Code

touch .zshrc_secrets

# Clone wal
git clone https://github.com/dylanaraps/wal.git ~/src/wal/

# Clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Work stuff
pacaur -Sy --noedit --noconfirm rbenv

echo '########## DONE - Droping into a shell: ##############'
bash
