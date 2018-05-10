#!/bin/bash -l
echo '######################################################'
echo '########### INSTALLING STUFF ############'
echo '######################################################'
cd

pacaur -Sy --noedit --noconfirm vim-runtime vim-airline vim-airline-themes
pacaur -Sy --noedit --noconfirm i3-gaps i3status rxvt-unicode stow xterm rofi
pacaur -Sy --noedit --noconfirm powerline powerline-common powerline-fonts-git
pacaur -Sy --noedit --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
pacaur -Sy --noedit --noconfirm xorg-server xorg-xinit xf86-video-fbdev
pacaur -Sy --noedit --noconfirm firefox lastpass imagemagick feh

# dev toolchain
pacaur -Sy --noedit --noconfirm rbenv ruby ruby-build openssl
rbenv install 2.4.0

echo '############# Clone dotfiles ##############'
git clone https://github.com/markitoxs/.dotfiles.git

# Apply the dotfiles
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

########################################
# Handle Zsh customization
########################################

# Clone oh-my-zsh for agnoster theme and such
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Clone wal
git clone https://github.com/dylanaraps/wal.git ~/src/wal/

# Clone album with wallpapers
mkdir -p ~/img/

# SSH KEY STUFF
# tar cz folder_to_encrypt | openssl enc -aes-256-cbc -e > out.tar.gz.enc
# openssl enc -aes-256-cbc -d -in out.tar.gz.enc | tar xz
scp root@192.168.1.10:/mnt/tera/ssh.tar.gz.enc /tmp/
openssl enc -aes-256-cbc -d -in /tmp/ssh.tar.gz.enc | tar xz
srm /tmp/ssh.tar.gz.enc

echo '########## DONE - Droping into a shell: ##############'
/usr/bin/zsh
