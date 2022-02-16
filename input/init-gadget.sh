#!/sbin/openrc-run
# shellcheck shell=ash

# shellcheck disable=SC2034
description="Use the raspberry pi as gadget"

depend()
{
	need loopback
}

start()
{
	ebegin "Starting gadget"
	/usr/bin/gadget-configure.sh
	/usr/bin/gadget-network.sh
	eend 0
}

stop()
{
	ebegin "Stopping the gadget"
	echo "not implemented"
	eend 1
}
