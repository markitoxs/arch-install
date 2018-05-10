#!/bin/bash -l
# Install pacaur
set -e 
set TERM=xterm

# Install pacaur
echo '######################################################'
echo '############ Installing  PACAUR ######################'
echo '######################################################'
cd /tmp || exit 1
buildroot="$(mktemp -d)"
sudo -v
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
sudo pacman -S --needed --noconfirm base-devel git pkgfile
mkdir -p "$buildroot"
cd "$buildroot" || exit 1
git clone "https://aur.archlinux.org/cower.git"
git clone "https://aur.archlinux.org/pacaur.git"
cd "${buildroot}/cower" || exit 1
makepkg --syncdeps --install --noconfirm
cd "${buildroot}/pacaur" || exit 1
makepkg --syncdeps --install --noconfirm
cd /tmp || exit 1
rm -rf "$buildroot"


file="/usr/bin/pacaur"
if [ -f "$file" ]
then
	echo "$file found."
else
  echo '######################################################'
	echo "ERROR: $file not found."
  echo '######################################################'
  echo 'Dropping into shell'
  bash
fi
