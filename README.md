# Debian Distribution Build

## Table of Contents :memo:
- [Introduction](#introduction)
- [Installation](#installation)
- [The Basics](#the-basics)
  - [What is a live system](#what-is-a-live-system)
- [Overview of tools](#overview-of-tools)
- [Building OS](#building-os)
  - [Managing Configuration](#managing-configuration)
  - [Customizing the Skeleton](###customizing-the-skeleton)
    - [Installing Distribution supported Packages](#installing-distribution-supported-packages)
    - [Installation of Additional Application](#installation-of-additional-application)
  - [Build the ISO](#build-the-iso)
    - [Interactive Shell](#interactive-shell)
  - [Testing](#testing)

## Introduction
`live-build` - the live systems tool suite
- __live-build__ is a set of scripts to build live system images. 
- The idea behind __live-build__ is a tool suite that uses a configuration directory to completely automate and customize all aspects of building a *Live image*.

## Installation
- Install *live-build*
`sudo apt install live-build`
- Install *xorriso* 
`sudo apt install xorriso`
- Install *[virtualbox](https://tecadmin.net/install-virtualbox-debian-9-stretch/)*

## The Basics
### What is a live system
- A __live system__ usually means an operating system booted on a computer from a removable medium, such as a *CD-ROM* or *USB stick*, or from a *network*, ready to use without any installation on the usual drive(s), with auto-configuration done at run time.
- A __live system__ is made from the following parts:
  - __Linux kernel image__, usually named `vmlinuz*`
  - __Initial RAM disk image (initrd)__: a RAM disk set up for the Linux boot, containing modules possibly needed to mount the System image and some scripts to do it. 
  - __System image__: The operating system's filesystem image. Usually, a *SquashFS* compressed filesystem is used to minimize the live system image size. Note that it is __read-only__. So, during boot the live system will use a RAM disk and *union* mechanism to enable writing files within the running system. However, all modifications will be lost upon shutdown unless optional *persistence* is used. 
  - __Bootloader__: A small piece of code crafted to boot from the chosen medium, possibly presenting a prompt or menu to allow selection of *options/configuration*. It loads the Linux kernel and its `initrd` to run with an associated system filesystem.

## Overview of tools
- __lb config__: Responsible for initializing a Live system configuration directory.
- __lb build__: Responsible for starting a Live system build.
- __lb clean__: Responsible for removing parts of a Live system build.

## Building OS
### Managing Configuration
- In terminal :
```
mkdir mylive 
cd mylive
lb config
```
`mylive` is the OS *home directory*
- Three directories are created `auto/`, `config/` and `local`
- The `lb config` command stores the options you pass to it in *config/*  files along with many other options set to default values
-  Now create a new file `auto/config`
```
nano auto/config
```
Now add the following lines
```
#!/bin/bash

set -e


#add your mirror
custom_os="http://debianmirror.nkn.in/debian"
dist="buster"

lb config noauto \
     --architectures amd64 \
     --archive-areas "main contrib non-free" \
     --interactive shell \
     --debian-installer live  \
     --debian-installer-gui true \
     --mirror-bootstrap "$custom_os" \
     --mirror-debian-installer "$custom_os" \
     --distribution "$dist" \
     --iso-application "custom-os" \
     --iso-publisher "mvs" \
     --iso-volume "custom-os Live" \
     --security false \
     --updates true \
     --memtest memtest86 \
	"${@}"

```
save and exit

### Customizing the Skeleton
- The `config` folder is where the skeleton of the ISO exists. Here we can add or change files to deep personalize our ISO
#### Installing Distribution supported Packages
- Package lists are a powerful way of expressing which packages should be installed.
- Create a new file called `config/package-lists/my.list.chroot` and add your packages which are supported by your distribution

In terminal
```
nano config/package-lists/my.list.chroot
```
Now add your packages
```
task-kde-desktop
debian-installer-launcher
git
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
emacs
apache2
python3-pip
kwin-addons
inkscape
gimp
audacity
kdenlive
blender
vlc
thunderbird

```
save and exit

#### Installation of Additional Application
- The folder `config/includes.chroot` contains the file structure of the new ISO. If you create a folder called `opt` inside, it will be the `/opt` folder inside the ISO.
- Create a new directory in `config/includes.chroot/opt`
- We can install these applications using `interactive shell` or `hooks`

In terminal
```
mkdir config/includes.chroot/opt/
```
Now inside add in your required applications (i.e., arduino software)
- Download [Arduino IDE](https://www.arduino.cc/en/main/software)
```
cp ~/Downloads/arduino-*.tar.xz config/includes.chroot/opt/
```

### Build the ISO
- Once Every thing is done go to the `mylive` home directory and build the OS
In terminal
```
sudo lb build 2>&1 | tee build.log
```
This generates the ISO from the Skeleton and a build log file  `build.log`. This process __takes sometime__ have some coffee :coffee:
- During the Process you will get a Interactive shell. Use that shell to install  [__Arduino IDE__](https://www.arduino.cc/en/guide/linux)
- Once you are done exit the shell by pressing `Ctrl+d` and the remaing process continues.

 After this process you will get a *mylive.iso*.
  
### Testing
- Test this ISO by either __virtualbox__ or copy it to a __pen-drive__
- Now clean the build directory using `lb clean`
 
# Congratulations :beer:
You have just created your Operating System
  

