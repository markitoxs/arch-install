#!/usr/bin/env bash
#
echo '########### INSTALLING STUFF ############'
cd
pacaur -Sy --noedit --noconfirm vim-runtime vim-airline vim-airline-themes
pacaur -Sy --noedit --noconfirm i3-gaps i3status rxvt-unicode stow xterm rofi
pacaur -Sy --noedit --noconfirm powerline powerline-common powerline-fonts-git
pacaur -Sy --noedit --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
pacaur -Sy --noedit --noconfirm xorg-server xorg-xinit
pacaur -Sy --noedit --noconfirm firefox imagemagick feh

# Clone repo
echo '############# Clone configs ##############'
git clone https://github.com/markitoxs/.dotfiles.git

cd .dotfiles

stow zsh
stow i3
# add loading
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

# Clone album with wallpapers
git clone https://github.com/alexgisby/imgur-album-downloader.git ~/src/imgur-album-downloader/
mkdir -p ~/img/
python ~/src/imgur-album-downloader/imguralbum.py http://imgur.com/a/0pe3o ~/img/
python ~/src/imgur-album-downloader/imguralbum.py http://imgur.com/a/XgYEs ~/img/

# Clone oh-my-zsh for agnoster theme and such
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Work stuff
pacaur -Sy --noedit --noconfirm rbenv

echo '########## DONE - Droping into a shell: ##############'
zsh
