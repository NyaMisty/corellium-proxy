#!/bin/bash

SUBNET=$(ip -o -f inet addr show dev eth0 | awk '{print $4}')
IPADDR=$(echo "${SUBNET}" | cut -f1 -d'/')
GATEWAY=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
eval $(ipcalc-ng -np "${SUBNET}")

ip rule add from "${IPADDR}" table 128
ip route add table 128 to "${NETWORK}/${PREFIX}" dev eth0
ip route add table 128 default via "${GATEWAY}"
