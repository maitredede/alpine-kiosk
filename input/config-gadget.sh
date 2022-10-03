#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing gadget"

# enable i2c
echo 'i2c-dev' >> "$ROOTFS_PATH"/etc/modules
echo 'dtparam=i2c_arm=on' >> "$BOOTFS_PATH"/config.txt

# enable spi
# echo 'dtparam=spi=on' >> "$BOOTFS_PATH"/config.txt

# enable gadget
echo 'dtoverlay=dwc2' >> "$BOOTFS_PATH"/config.txt
echo 'dwc2' >> "$ROOTFS_PATH"/etc/modules
echo 'libcomposite' >> "$ROOTFS_PATH"/etc/modules

cp ${INPUT_PATH}/gadget-configure.sh ${ROOTFS_PATH}/usr/bin/gadget-configure.sh
cp ${INPUT_PATH}/gadget-network.sh ${ROOTFS_PATH}/usr/bin/gadget-network.sh
cp ${INPUT_PATH}/init-gadget.sh ${ROOTFS_PATH}/etc/init.d/gadget
chroot_exec rc-update add gadget default

chroot_exec apk add dnsmasq
# chroot_exec rc-update delete dnsmasq default
cp ${INPUT_PATH}/init-gadget-link.sh ${ROOTFS_PATH}/etc/init.d/gadget-link
chroot_exec rc-update add gadget-link default
