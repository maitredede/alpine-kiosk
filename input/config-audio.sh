#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing audio"

# https://wiki.alpinelinux.org/wiki/Raspberry_Pi_Bluetooth_Speaker#Getting_the_Speaker.28s.29_Working

# enable basic audio
echo "dtparam=audio=on" >> "${BOOTFS_PATH}"/config.txt
echo "snd_bcm2835" >> "${ROOTFS_PATH}"/etc/modules
# # https://wiki.alpinelinux.org/wiki/PipeWire#Installation_and_configuration

# chroot_exec apk add pipewire wireplumber
# mkdir ${ROOTFS_PATH}/etc/pipewire
# cp ${ROOTFS_PATH}/usr/share/pipewire/pipewire.conf ${ROOTFS_PATH}/etc/pipewire/
# sed -i 's|context.exec = \[|context.exec = \[\n{ path = "wireplumber"  args = "" }|' ${ROOTFS_PATH}/etc/pipewire/pipewire.conf

# # for alsa support
# echo "snd_seq" >> "${ROOTFS_PATH}"/etc/modules
# mkdir -p ${ROOTFS_PATH}/etc/pipewire/media-session.d
# touch ${ROOTFS_PATH}/etc/pipewire/media-session.d/with-alsa
# chroot_exec apk add pipewire-alsa

# # start
# cp "${INPUT_PATH}/init-audio.sh" "$ROOTFS_PATH"/etc/init.d/pipewire
# chroot_exec rc-update add pipewire default

# https://wiki.alpinelinux.org/wiki/ALSA
chroot_exec apk add alsa-utils alsa-utils-doc alsa-lib alsaconf alsa-ucm-conf
chroot_exec addgroup root audio
chroot_exec rc-update add alsa default
