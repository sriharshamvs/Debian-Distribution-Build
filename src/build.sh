sudo apt install live-build
sudo apt install xorriso
mkdir build
cd build
lb config -d buster
touch auto/config

echo "#!/bin/bash

set -e


#add your mirror
mirror="http://debianmirror.nkn.in/debian"
dist="buster"

lb config noauto \
     --architectures amd64 \
     --archive-areas "main contrib non-free" \
     --interactive shell \
     --debian-installer true  \
     --debian-installer-gui true \
     --mirror-bootstrap "$mirror" \
     --mirror-debian-installer "$mirror" \
     --distribution "$dist" \
     --debian-installer-distribution "$dist" \
     --iso-application "alpha-os" \
     --iso-publisher "mvs" \
     --iso-volume "alpha Live" \
     --security false \
     --updates true \
     --memtest memtest86 \
	"${@}"
" >> auto/config

echo "gnome
calamares
calamares-settings-debian
debian-installer-launcher
iputils-ping
gparted
lvm2
htop
sudo
net-tools
cryptsetup
encfs
gpg
gnupg
curl
ufw
openssh-server
software-properties-common
apt-transport-https
build-essential
devscripts
wget
vim
python3-pip
git
emacs
inkscape
gimp
vlc
thunderbird
" >> config/package-lists/e-swecha-packages.list.chroot

mkdir config/includes.chroot/opt/

sudo lb build 2>&1 | tee build.log
