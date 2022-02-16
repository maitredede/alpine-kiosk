#!/sbin/openrc-run
# shellcheck shell=ash

command="/usr/bin/pipewire"
# pidfile="/var/run/${RC_SVCNAME}.pid"
# command_args=""
command_background=true

depend() {
	use dbus
	after dbus
}