#!/bin/ash

# Source: https://github.com/raspi-alpine/builder
# Variables :
# INPUT_PATH	Path to input directory
# ROOTFS_PATH	Path to new root filesystem
# BOOTFS_PATH	Path to new boot filesystem
# DATAFS_PATH	Path to new data filesystem

set -euo pipefail

################################################################
# Configuration
export USE_CACHE=${USE_CACHE:-"false"}

export LIBNFC=${LIBNFC:-"libnfc-1.8.0"}
export LIBFREEFARE=${LIBFREEFARE:-"master"}

export X11VNC_PASSWORD=${X11VNC_PASSWORD:-"vncproot"}
################################################################

chroot_exec apk upgrade --available
# raspberrypi
chroot_exec apk add dropbear-scp haveged nano
chroot_exec rc-update add haveged boot
mkdir -p ${DATAFS_PATH}/root/.ssh
cat >> ${DATAFS_PATH}/root/.ssh/authorized_keys << EOF
EOF

# Cache
#export CACHE_PATH=${INPUT_PATH}/.cache-${ARCH}
if [ "${USE_CACHE}" != "true" ]
then
    rm -rf ${CACHE_PATH}
fi
mkdir -p ${CACHE_PATH}

# First, build app (or dependency packages would be removed on cleanup)
. ${INPUT_PATH}/config-app.sh

. ${INPUT_PATH}/config-wifi.sh
. ${INPUT_PATH}/config-dbus.sh
. ${INPUT_PATH}/config-audio.sh
. ${INPUT_PATH}/config-xorg.sh
. ${INPUT_PATH}/config-opengl.sh
. ${INPUT_PATH}/config-gadget.sh
. ${INPUT_PATH}/config-kiosk.sh
. ${INPUT_PATH}/config-devtools.sh

rm -f ${ROOTFS_PATH}/bin/bbsuid
