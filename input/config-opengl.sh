#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing OpenGL accelerations"

# OpenGL for rpi4

# https://wiki.alpinelinux.org/wiki/Raspberry_Pi#Enable_OpenGL_.28Raspberry_Pi_3.2F4.29

sed -i 's|gpu_mem=16|# gpu_mem=16|' ${BOOTFS_PATH}/config.txt
sed -i 's|gpu_mem_256=64|# gpu_mem_256=64|' ${BOOTFS_PATH}/config.txt
echo "gpu_mem=256" >> ${BOOTFS_PATH}/config.txt
echo "dtoverlay=vc4-fkms-v3d" >> ${BOOTFS_PATH}/config.txt
chroot_exec apk add mesa-dri-gallium
