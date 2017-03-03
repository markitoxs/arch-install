#!/bin/bash
HOST=jorgito
USERNAME=markitoxs
HOME_DIR="/home/${USERNAME}"
SWAP_SIZE=4G

# mount run to bypass lvmetadata errors
mkdir /run/lvm
mount --bind /hostrun/lvm /run/lvm

# Add 'ext4' to MODULES
# Add 'encrypt' and 'lvm2' to HOOKS before filesystems
sudo sed -i 's/MODULES=""/MODULES="ext4"/g' /etc/mkinitcpio.conf
sudo sed -i 's/filesystems keyboard fsck/encrypt lvm2 filesystems keyboard fsck/g' /etc/mkinitcpio.conf

# regenerate
mkinitcpio -p linux

# grub as a bootloader
grub-install --target=i386-pc --recheck /dev/sda

# Customize grub config
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
sudo sed -i 's@GRUB_CMDLINE_LINUX=""@GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda3:luks:allow-discards"@g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# run these following essential service by default
systemctl enable sshd.service
systemctl enable dhcpcd.service
systemctl enable ntpd.service

echo "$HOST" > /etc/hostname

## inject vimrc config to default user dir if you like vim
echo -e 'runtime! archlinux.vim\nsyntax on' > /etc/skel/.vimrc

## adding your normal user with additional wheel group so can sudo
useradd -m -G wheel -s /bin/bash "$USERNAME"

## adding public key both to root and user for ssh key access
mkdir -m 700 "$HOME_DIR/.ssh"
mkdir -m 700 /root/.ssh
cp /authorized_keys "/$HOME_DIR/.ssh"
cp /authorized_keys /root/.ssh
chown -R "$USERNAME:$USERNAME" "$HOME_DIR/.ssh"

## adjust your timezone here
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

# creating the swap file, if you have enough RAM, you can skip this step
fallocate -l "$SWAP_SIZE" /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo /swapfile none swap defaults 0 0 >> /etc/fstab

# auto-complete these essential commands
echo complete -cf sudo >> /etc/bash.bashrc
echo complete -cf man >> /etc/bash.bashrc

# Install pacaur
./pacaur.sh
