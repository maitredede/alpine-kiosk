#!/sbin/openrc-run
# shellcheck shell=ash

command="/usr/bin/xinit"
pidfile="/var/run/${RC_SVCNAME}.pid"
command_args="/usr/bin/kiosk-launch.sh"
command_background=true

depend() {
	# use gadget gadget-link nfc-websocket
	# use gadget gadget-link
	need dbus alsa
	use gadget gadget-link nfc-websocket
}