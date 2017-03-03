#!/bin/bash
DISK="/dev/$1"
BOOT="${DISK}2"
ROOT="${DISK}3"

# Create a DOS partition table
parted -s "$DISK" mklabel gpt

# Create some partitions
#+-----------+------+-------+-----------+
#| Partition | Name | Size  | Flags     |
#+-----------+------+-------+-----------+
#| /dev/sda1 | grub | 2MB   | bios_grub |
#| /dev/sda2 | boot | 200MB | boot      |
#| /dev/sda3 | lvm  |       | lvm       |
#+-----------+------+-------+-----------+
# GPT
parted $DISK --script -- mklabel gpt

# GRUB
parted $DISK --script -- mkpart primary 0MB 2MB
parted $DISK --script -- name 1 bios_grub
parted $DISK --script -- set 1 bios_grub

# BOOT
parted $DISK --script -- mkpart primary ext2 2MB 512MB
parted $DISK --script -- name 2 boot
parted $DISK --script -- set 2 boot on

# Create ext2
mkfs.ext2 /dev/sda2

# LVM
parted $DISK --script -- mkpart primary ext4 512MB 100%
parted $DISK --script -- name 3 lvm
parted $DISK --script -- set 3 lvm on

echo 'Drive formatted as:'
parted $DISK --script -- print


# Encryption 
cryptsetup --verbose --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random luksFormat "$ROOT"
cryptsetup luksOpen "$ROOT" luks

# Create encrypted partitions
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate --size 4G vg0 --name swap  #Change this depending on your ram
lvcreate -l +100%FREE vg0 --name root

# Create filesystems on encrypted partitions
mkfs.ext4 /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap

mount /dev/mapper/vg0-root /mnt # /mnt is the installed system
swapon /dev/mapper/vg0-swap # Not needed but a good thing to test

mkdir /mnt/boot
mount "$BOOT" /mnt/boot

# Prepare mirrors stuff
# you can find your closest server from: https://www.archlinux.org/mirrorlist/all/
echo 'Server = http://mirrors.cat.pdx.edu/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
pacman -Syy

# would recommend to use linux-lts kernel if you are running a server environment, otherwise just use "linux"
pacstrap /mnt $(pacman -Sqg base) base-devel grub openssh sudo ntp wget vim

genfstab -pU /mnt >> /mnt/etc/fstab

# Add tmp as a ramdisk
echo "tmpfs	/tmp	tmpfs	defaults,noatime,mode=1777	0	0" >> /mnt/etc/fstab

# Prepare to chroot
cp ./chroot.sh /mnt
cp ~/.ssh/authorized_keys /mnt
echo "##################################################"
echo "##################################################"
echo "Entering the new system"
# Enter the new system & Execute new stuff
arch-chroot /mnt ./chroot.sh

# Prepare to install pacaur
cp ./pacaur.sh /mnt

## Once done remove non necessary files and reboot
rm /mnt/chroot.sh
rm /mnt/authorized_keys
umount -R /mnt
systemctl reboot
