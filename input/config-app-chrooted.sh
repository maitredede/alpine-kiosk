#!/bin/ash

set -euo pipefail

# export LIBNFC=${LIBNFC:-"libnfc-1.8.0"}
# export LIBFREEFARE=${LIBFREEFARE:-"master"}

WRKDIR=/wrk
PREFIX_NFC=${WRKDIR}/usr-libnfc
PREFIX_FREEFARE=${WRKDIR}/usr-libfreefare
SRC_NFC=${WRKDIR}/src-libnfc
SRC_FREEFARE=${WRKDIR}/src-libfreefare
SRC_APP=${WRKDIR}/app
RESULT=${WRKDIR}/result

apk add --virtual .build-deps git build-base autoconf automake make linux-headers gettext libtool libusb-dev libusb-compat-dev pkgconf bsd-compat-headers openssl-dev go libcec-dev

cd ${SRC_NFC}
# git clone https://github.com/nfc-tools/libnfc.git . --depth=1 --recursive --branch ${LIBNFC}
autoreconf -vis
./configure --prefix=${PREFIX_NFC} --exec-prefix=/usr
# ./configure --prefix=${PREFIX_NFC} --build x86_64-pc-linux-gnu --host aarch64-linux-gnu LDFLAGS="-static -pthread" --enable-mpers=check
make -j`nproc` CFLAGS+=-D_GNU_SOURCE
make install
cp -rv ${PREFIX_NFC}/* /usr/

cd ${SRC_FREEFARE}
autoreconf -vis
./configure --prefix=${PREFIX_FREEFARE} --exec-prefix=/usr
# ./configure --prefix=${PREFIX_FREEFARE} --build x86_64-pc-linux-gnu --host aarch64-linux-gnu LDFLAGS="-static -pthread" --enable-mpers=check
make -j`nproc`
make install
cp -rv ${PREFIX_FREEFARE}/* /usr/

mkdir -p /etc/nfc
cat << EOF >> /etc/nfc/libnfc.conf
# Allow device auto-detection (default: true)
# Note: if this auto-detection is disabled, user has to set manually a device
# configuration using file or environment variable
#allow_autoscan = true

# Allow intrusive auto-detection (default: false)
# Warning: intrusive auto-detection can seriously disturb other devices
# This option is not recommended, user should prefer to add manually his device.
#allow_intrusive_scan = false

# Set log level (default: error)
# Valid log levels are (in order of verbosity): 0 (none), 1 (error), 2 (info), 3 (debug)
# Note: if you compiled with --enable-debug option, the default log level is "debug"
#log_level = 1

# Manually set default device (no default)
# To set a default device, you must set both name and connstring for your device
# Note: if autoscan is enabled, default device will be the first device available in device list.
#device.name = "microBuilder.eu"
#device.connstring = "pn532_uart:/dev/ttyUSB0"
device.name = "_PN532_I2c"
device.connstring = "pn532_i2c:/dev/i2c-1"
EOF

mkdir -p ${RESULT}/usr/bin/ ${RESULT}/etc/nfc/
cp -rv ${PREFIX_NFC}/* ${RESULT}/usr/
cp -rv ${PREFIX_FREEFARE}/* ${RESULT}/usr/
cp -v /etc/nfc/libnfc.conf ${RESULT}/etc/nfc/libnfc.conf

cd ${SRC_APP}
export GOPATH=${WRKDIR}/go
mkdir -p ${GOPATH}

go version
go env

export GOCACHE=${WRKDIR}/.go-cache/

# go mod download
# go build -v -o /usr/bin/nfc-websocket .
# cp /usr/bin/nfc-websocket ${RESULT}/usr/bin/nfc-websocket

apk del .build-deps
