# batman-adv-instructions

# Preqs
32byte headers will be added. Reduce the bat0 MTU to 1468, or increase the wifi MTU 1532

# stop services that will break the mesh
systemctl disable --now wpa_supplicant
systemctl disable --now dhcpd
systemctl disable --now hostapd

# Install batctl and tools
apt install libnl-3-dev libnl-genl-3-dev ip-tools
git clone https://github.com/open-mesh-mirror/batctl.git
cd batctl
make install

apt install alfred # optional utils

# load batman-adv module
modprobe batman-adv

# configure wifi interface
ip link set wlan0 down #disable interface

ip link set dev wlan0 mtu 1532 # default MTU
OR
ip link set dev bat0 mtu 1468

iwconfig wlan0 mode ad-hoc
iwconfig wlan0 essid my-mesh-network
iwconfig wlan0 ap any
iwconfig wlan0 channel 8
sleep 1
ip link set wlan0 up

# configure bat0 interface
batctl if add wlan0
sleep 1
ip link set bat0 up
sleep 5
ip addr add 192.168.222.1/24 dev bat0


# check connectivity
iwconfig # check all nodes show same essid, freq, and Cell ID
wlan should NOT have a IP address

batctl o # show originators
batctl n # show neighbours
ping 192.168.222.2
batctl ping MAC
batctl tg # transglobal table


# trouble shooting
## enable multicast
net.ipv4.icmp_echo_ignore_broadcasts=0 in /etc/sysctl.conf
service procps restart

## disable wifi power saving
WIFI_PWR_ON_AC =1
WIFI_PWR_ON_BAT = 1
/etc/default/tlp
  
# refs 
