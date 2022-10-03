#!/bin/sh

# device manager service for device creation and /dev/stderr etc
case ${DEV} in
  eudev)
    # chroot_exec setup-udev -n
    # chroot_exec setup-devd -C udev
    if chroot_exec rc-service --exists mdev ; then
      chroot_exec rc-service --ifstarted --quiet hwdrivers stop
      chroot_exec rc-service --ifstarted --quiet mdev stop
      chroot_exec rc-update delete --quiet hwdriver sysinit || :
      chroot_exec rc-update delete --quiet mdev sysinit || :
    fi
    if chroot_exec rc-service --exists mdevd ; then
      chroot_exec rc-service --ifstarted --quiet mdevd stop
      chroot_exec rc-update delete --quiet mdevd-init sysinit 2>/dev/null || :
      chroot_exec rc-update delete --quiet mdevd sysinit 2>/dev/null || :
    fi

    chroot_exec apk add eudev udev-init-scripts udev-init-scripts-openrc
    chroot_exec rc-update add --quiet udev sysinit
    chroot_exec rc-update add --quiet udev-trigger sysinit
    chroot_exec rc-update add --quiet udev-settle sysinit
    chroot_exec rc-update add --quiet udev-postmount default
    # chroot_exec rc-service --ifstopped udev start
    # chroot_exec rc-service --ifstopped udev-trigger start
    # chroot_exec rc-service --ifstopped udev-settle start
    # chroot_exec rc-service --ifstopped udev-postmount start

    install ${RES_PATH}/scripts/ab_root.sh ${ROOTFS_PATH}/etc/init.d/ab_root
    DEFAULT_SERVICES="${DEFAULT_SERVICES} ab_root"
    if [ "$DEFAULT_KERNEL_MODULES" != "*" ]; then
      DEFAULT_KERNEL_MODULES="$DEFAULT_KERNEL_MODULES uio bcm2835-mmal-vchiq brcmutil cfg80211 videobuf2-vmalloc videobuf2-dma-contig v4l2-mem2mem"
    fi
    ;;
  *)
    SYSINIT_SERVICES="${SYSINIT_SERVICES} mdev"
    ;;
esac
