#!/bin/sh


INTERFACE=enp0s3
IP=10.10.10.2

systemctl disable --now NetworkManager

apt install libnl-3-dev libnl-genl-3-dev net-tools gcc git make -y

apt install alfred -y

modprobe batman-adv

batctl -v

#disable eth interface
ip link set ${INTERFACE} down

#clear existing settings
ip addr flush dev ${INTERFACE}

ip link set dev ${INTERFACE} mtu 1532

ip link set ${INTERFACE} up

batctl if add ${INTERFACE}

ip link set bat0 up

ip addr add ${IP}/24 dev bat0

#iwconfig

sleep 1

batctl if
