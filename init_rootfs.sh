#!/bin/bash


# Execute as root
if [ $(id -u) -ne 0 ]; then
    sudo $0 $@
    exit $?
fi

# Read config
. $(dirname $(readlink -f $0) )/config

[ -n "$PIBASE" ] || exit 1


# Get some packages.
apt install qemu-user-static debootstrap

# This step takes a little while.  Don't do it on a low battery.
qemu-debootstrap --arch armhf $RELEASE $ROOTFS http://archive.raspbian.org/raspbian

# Add the Raspbian repo and set up a GPG key.
echo "deb http://archive.raspberrypi.org/debian/ stretch main" > /etc/apt/sources.list
echo "deb http://archive.raspbian.org/raspbian stretch main contrib non-free rpi firmware" >> /etc/apt/sources.list

chroot-pi 'wget -O- http://archive.raspbian.org/raspbian.public.key | apt-key add -'
chroot-pi 'wget --no-check-certificate -O- https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -'
chroot-pi 'apt update && apt install sudo build-essential libaio-dev zlib1g-dev wiringpi'
