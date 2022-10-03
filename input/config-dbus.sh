#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing dbus"

# https://wiki.alpinelinux.org/wiki/PipeWire#D-Bus

chroot_exec apk add dbus dbus-openrc dbus-x11
chroot_exec rc-update add dbus default
