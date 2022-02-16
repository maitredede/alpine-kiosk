#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing dev tools"

cp -rv ${INPUT_PATH}/devtools/* ${ROOTFS_PATH}/usr/bin/
