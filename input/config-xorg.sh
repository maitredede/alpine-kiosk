#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing Xorg"

# xorg base
# https://github.com/alpinelinux/alpine-conf/blob/master/setup-xorg-base.in
# chroot_exec apk add xorg-server xf86-input-libinput mesa xf86-video-fbdev xset eudev eudev-openrc
# chroot_exec apk add xorg-server xf86-input-libinput mesa

# from setup-xorg-base : https://github.com/alpinelinux/alpine-conf/blob/master/setup-xorg-base.in
chroot_exec apk add xorg-server xf86-input-libinput eudev mesa
# chroot_exec setup-udev -n

chroot_exec apk add xf86-input-evdev xf86-video-fbdev xset
# chroot_exec setup-udev -n

# mkdir -p ${ROOTFS_PATH}/var/log/
# ln -fs /data/var/log/Xorg.0.log ${ROOTFS_PATH}/var/log/Xorg.0.log
# mkdir -p ${DATAFS_PATH}/var/log
# touch ${DATAFS_PATH}/var/log/Xorg.0.log

# move /var/log as tmpfs for X

# mkdir -p ${ROOTFS_PATH}/root/.cache
cat << EOF >> ${ROOTFS_PATH}/etc/fstab

tmpfs           /var/log        tmpfs  defaults             0 0
EOF


# Window manager
chroot_exec apk add bspwm
# TODO add bspwm configuration

# fonts
# chroot_exec apk add terminus-font ttf-inconsolata ttf-dejavu font-noto ttf-font-awesome font-noto-extra

# Add gstreamer to display youtube videos
chroot_exec apk add gst-libav
