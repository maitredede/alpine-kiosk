#!/sbin/openrc-run

description="A lightweight DNS, DHCP, RA, TFTP and PXE server"

extra_commands="checkconfig"
description_checkconfig="Check configuration syntax"

extra_started_commands="reload"
description_reload="Clear cache and reload hosts files"

DNSMASQ_CONFFILE=/tmp/${RC_SVCNAME}.conf
leasefile=/tmp/${RC_SVCNAME}.leases

command="/usr/sbin/dnsmasq"
# Tell dnsmasq to not create pidfile, that's responsibility of init system.
command_args="-k --pid-file= --conf-file=${DNSMASQ_CONFFILE} --dhcp-leasefile=${leasefile}"
command_background="yes"
pidfile="/run/${RC_SVCNAME}.pid"

depend() {
	need localmount net gadget
	after bootmisc
	use logger
}

reload() {
	ebegin "Reloading $RC_SVCNAME"
	$command --test --conf-file=$DNSMASQ_CONFFILE >/dev/null 2>&1 \
		|| $command --test || return 1
	start-stop-daemon --signal HUP --pidfile "$pidfile"
	eend $?
}

checkconfig() {
	ebegin "Checking $RC_SVCNAME configuration"
	$command --test --conf-file=$DNSMASQ_CONFFILE --dhcp-leasefile=${leasefile}
	eend $?
}
