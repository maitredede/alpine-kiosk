#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing x11vnc"

chroot_exec apk add x11vnc

# TODO x11vnc password
# TODO x11vnc service
