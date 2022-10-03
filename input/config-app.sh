#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing NFC libraries and application"

LIBNFC=${LIBNFC:="libnfc-1.8.0"}
LIBFREEFARE=${LIBFREEFARE:="master"}

CURDIR=${PWD}
WRKDIR=${ROOTFS_PATH}/wrk
SRC_NFC=${WRKDIR}/src-libnfc
SRC_FREEFARE=${WRKDIR}/src-libfreefare
SRC_APP=${WRKDIR}/app
RESULT_CACHE=${CACHE_PATH}/${ARCH}/app-cache
RESULT=${WRKDIR}/result

CACHE_NFC_SRC=${CACHE_PATH}/${ARCH}/src-libnfc
CACHE_FREEFARE_SRC=${CACHE_PATH}/${ARCH}/src-libfreefare

colour_echo ">>> Installing NFC application"

if [ -d ${RESULT_CACHE} ]; then
    echo "Using cached application build result (cache=${RESULT_CACHE})"
    cp -rv ${RESULT_CACHE}/* ${ROOTFS_PATH}
else
    echo "Rebuild app (cache=${RESULT_CACHE})"
    mkdir -p ${WRKDIR} ${SRC_NFC} ${SRC_FREEFARE} ${SRC_APP} ${RESULT}

    #######################
    # Checkout libnfc
    if [ ! -d ${CACHE_NFC_SRC} ]; then
        mkdir -p ${CACHE_NFC_SRC}
        git clone https://github.com/nfc-tools/libnfc.git ${CACHE_NFC_SRC} --depth=1 --recursive --branch ${LIBNFC}
    fi
    cp -rv ${CACHE_NFC_SRC}/* ${SRC_NFC}

    #######################
    # Checkout libfreefare
    if [ ! -d ${CACHE_FREEFARE_SRC} ]; then
        mkdir -p ${CACHE_FREEFARE_SRC}
        git clone https://github.com/nfc-tools/libfreefare.git ${CACHE_FREEFARE_SRC} --depth=1 --recursive --branch ${LIBFREEFARE}
    fi
    cp -rv ${CACHE_FREEFARE_SRC}/* ${SRC_FREEFARE}

    cp -r ${INPUT_PATH}/app/* ${SRC_APP}

    cp ${INPUT_PATH}/config-app-chrooted.sh ${WRKDIR}
    chroot_exec /wrk/config-app-chrooted.sh

    mkdir -p ${RESULT_CACHE}
    cp -rv ${RESULT}/* ${RESULT_CACHE}
    rm -r ${WRKDIR}
fi

chroot_exec apk add libusb libusb-compat usbutils libcec

cp ${INPUT_PATH}/init-nfc-websocket.sh "$ROOTFS_PATH"/etc/init.d/nfc-websocket
chroot_exec rc-update add nfc-websocket default
