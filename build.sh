#!/bin/bash

set -eEuo pipefail

# https://github.com/raspi-alpine/builder

TAG_BUILDER="registry.gitlab.com/raspi-alpine/builder/master"
#TAG_BUILDER="ghcr.io/raspi-alpine/builder"
# TAG_BUILDER="ghcr.io/raspi-alpine/builder:20220205_090949"

docker pull ${TAG_BUILDER}

mkdir -p ${PWD}/input ${PWD}/output ${PWD}/work ${PWD}/cache

#https://gitlab.com/raspi-alpine/builder#arch-variable
# ARCH="armhf"
# ARCH="armv7"
ARCH="aarch64"

# docker run --privileged --rm multiarch/qemu-user-static --persistent yes || true
docker run --rm -it \
    -v ${PWD}/input:/input \
    -v ${PWD}/output:/output \
    -v ${PWD}/work:/work \
    --env ALPINE_BRANCH=edge \
    --env ALPINE_MIRROR=http://mirror.lagoon.nc/alpine \
    --env ARCH=${ARCH} \
    --env DEFAULT_HOSTNAME=thepigadget \
    --env DEFAULT_TIMEZONE=Pacific/Noumea \
    --env DEFAULT_ROOT_PASSWORD=proot \
    --env DEFAULT_KERNEL_MODULES="*" \
    --env SIZE_ROOT_PART="2G" \
    --env SIZE_ROOT_FS="2000M" \
    --env SIZE_DATA="1G" \
    --env CGO_ENABLED=1 \
    --env LIBNFC="libnfc-1.8.0" \
    --env LIBFREEFARE="master" \
    --env USE_CACHE="true" \
    --env CACHE_PATH=/input/.cache-${ARCH} \
    ${TAG_BUILDER}
