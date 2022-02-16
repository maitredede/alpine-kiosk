#!/bin/ash

set -euo pipefail

colour_echo ">>> Installing wifi"

# wifi stuff
chroot_exec apk add --no-cache wireless-tools wpa_supplicant
chroot_exec rc-update add wpa_supplicant default
echo "brcmfmac" >> "$ROOTFS_PATH"/etc/modules

cat >> "$ROOTFS_PATH"/etc/network/interfaces.alpine-builder <<EOF

auto wlan0
iface wlan0 inet dhcp
EOF

cp "$ROOTFS_PATH"/etc/network/interfaces.alpine-builder "$DATAFS_PATH"/etc/network/interfaces

WPA_PATH=/etc/wpa_supplicant
WPA_CONF=${WPA_PATH}/wpa_supplicant.conf
WPA_CONF_HOST=${ROOTFS_PATH}${WPA_PATH}/wpa_supplicant.conf
mkdir -p ${WPA_PATH}
touch ${WPA_CONF}

# ** CHANGE MYSSID and MYPSK **
chroot_exec sh -c "wpa_passphrase 'wifi1' 'wifipass' >> ${WPA_CONF}"
# can be used more than once to add more networks
chroot_exec sh -c "wpa_passphrase 'wifi2' 'wifipass' >> ${WPA_CONF}"
chroot_exec sh -c "wpa_passphrase 'wifi3' 'wifipass' >> ${WPA_CONF}"
# ** CHANGE MYSSID and MYPSK **

cat >> ${WPA_CONF_HOST} << EOF
ap_scan=1
autoscan=periodic:10
disable_scan_offload=1
EOF
chroot_exec rc-update add wpa_cli boot

#wpa_supplicant -u -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf