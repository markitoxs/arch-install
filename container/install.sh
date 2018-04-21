systemctl disable systemd-networkd 
dhcpcd eth0 
pacman -Sy --noconfirm base-devel zsh git vim

# Set up user
USERNAME=markitoxs
HOME_DIR="/home/${USERNAME}"

echo -e 'runtime! archlinux.vim\nsyntax on' > /etc/skel/.vimrc

## adding your normal user with additional wheel group so can sudo
useradd -m -G wheel -s /bin/zsh "$USERNAME"

ln -f -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

# adjust your name servers here if you don't want to use google
echo 'name_servers="8.8.8.8 8.8.4.4"' >> /etc/resolvconf.conf
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen

# because we are using ssh keys, make sudo not ask for passwords
echo 'root ALL=(ALL) ALL' > /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# I like to use vim :)
echo -e 'EDITOR=vim' > /etc/environment

# prevent zsh setup
sudo -u markitoxs touch /home/markitoxs/.zshrc

# Switch to user
sudo -u markitoxs bash << EOF
mkdir ~/src/
cd ~/src/
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si --install --noconfirm


# now we have trizen!
trizen -Sy --noedit --noconfirm vim-runtime vim-airline vim-airline-themes
trizen -Sy --noedit --noconfirm powerline powerline-common powerline-fonts-git
trizen -Sy --noedit --noconfirm terraform visual-studio-code-bin
EOF
