#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing kiosk"

# chroot_exec apk add --no-cache chromium chromium-lang
chroot_exec apk add --no-cache midori midori-lang chromium chromium-lang

cp ${INPUT_PATH}/kiosk-launch.sh ${ROOTFS_PATH}/usr/bin/kiosk-launch.sh
cp ${INPUT_PATH}/init-kiosk.sh ${ROOTFS_PATH}/etc/init.d/kiosk
chroot_exec rc-update add kiosk default
