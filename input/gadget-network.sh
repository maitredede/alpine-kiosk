#!/bin/ash

set -euo pipefail


# Waiting for one of the interfaces to get a link (either RNDIS or ECM)
#    loop count is limited by $RETRY_COUNT_LINK_DETECTION, to continue execution if this is used 
#    as blocking boot script
#    note: if the loop count is too low, windows may not have enough time to install drivers

# ToDo: check if operstate could be used for this, without waiting for carrieer
active_interface="none"

# if RNDIS and ECM are active check which gets link first
# Note: Detection for RNDIS (usb0) is done first. In case it is active, link availability
#	for ECM (usb1) is checked anyway (in case both interfaces got link). This is done
#	to use ECM as prefered interface on MacOS and Linux if both, RNDIS and ECM, are supported.
# if $USE_RNDIS && $USE_ECM; then
    # bring up both interfaces to check for physical link
    ifconfig usb0 up
    ifconfig usb1 up

    echo "CDC ECM and RNDIS active. Check which interface has to be used via Link detection"
    while [ "$active_interface" == "none" ]; do
    #while [[ $count -lt $RETRY_COUNT_LINK_DETECTION ]]; do
        printf "."
        USB0C=$(cat /sys/class/net/usb0/carrier 2>/dev/null|| echo "0")
        if [ "${USB0C}" == "1" ]; then
            # special case: macOS/Linux Systems detecting RNDIS should use CDC ECM anyway
            # make sure ECM hasn't come up, too
            sleep 0.5
            USB1C=$(cat /sys/class/net/usb1/carrier 2>/dev/null|| echo "0")
            if [ "${USB1C}" == "1" ]; then
                echo "Link detected on usb1"; sleep 2
                active_interface="usb1"
                ifconfig usb0 down

                break
            fi

            echo "Link detected on usb0"; sleep 2
            active_interface="usb0"
            ifconfig usb1 down

            break
        fi

        # check ECM for link
        USB1C=$(cat /sys/class/net/usb1/carrier 2>/dev/null|| echo "0")
        if [ "${USB1C}" == "1" ]; then
            echo "Link detected on usb1"; sleep 2
            active_interface="usb1"
            ifconfig usb0 down

            break
        fi


        sleep 0.5
    done
# fi

# # if eiter one, RNDIS or ECM is active, wait for link on one of them
# if ($USE_RNDIS && ! $USE_ECM) || (! $USE_RNDIS && $USE_ECM); then 
#     # bring up interface
#     ifconfig usb0 up

#     echo "CDC ECM or RNDIS active. Check which interface has to be used via Link detection"
#     while [ "$active_interface" == "none" ]; do
#         printf "."

#         if [[ $(</sys/class/net/usb0/carrier) == 1 ]]; then
#             echo "Link detected on usb0"; sleep 2
#             active_interface="usb0"
#             break
#         fi
#     done
# fi


echo ${active_interface}

SELF_IP=10.0.0.1
HOST_IP=10.0.0.2
BROADCAST=10.0.0.3
NETMASK=255.255.255.252

ifconfig ${active_interface} ${SELF_IP} netmask ${NETMASK}
route add -net default gw ${HOST_IP}

rm -f /tmp/gadget-link.conf /tmp/gadget-link.leases
cat << EOF > /tmp/gadget-link.conf
domain-needed
expand-hosts
bogus-priv

interface=${active_interface}
cache-size=0

dhcp-range=${HOST_IP},${HOST_IP},${NETMASK},${BROADCAST},5m
dhcp-option=3
EOF


# # setup active interface with correct IP
# if [ "$active_interface" != "none" ]; then
#     ifconfig $active_interface $IF_IP netmask $IF_MASK
# fi


# # if active_interface not "none" (RNDIS or CDC ECM are running)
# #	if [ "$active_interface" != "none" ]; then
# #		# setup DHCP server
# #		start_DHCP_server
# #
# #		# call onNetworkUp() from payload
# #		declare -f onNetworkUp > /dev/null && onNetworkUp
# #
# #		# wait for client to receive DHCP lease
# #		target_ip=""
# #		while [ "$target_ip" == "" ]; do
# #			target_ip=$(cat /tmp/dnsmasq.leases | cut -d" " -f3)
# #		done
# #
# #		# call onNetworkUp() from payload
# #		declare -f onTargetGotIP > /dev/null && onTargetGotIP
# #	fi
