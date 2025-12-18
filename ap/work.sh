#!/bin/bash

AP_INTERFACE=wlp0s20f3
INTERNET_INTERFACE=eno1
WI_INDEX="2"
STEAL_FROM_NM=1
LAUNCH_UXPLAY=1
UXPLAY_BUILD_DIR=${HOME}/repos/UxPlay/build
UXPLAY_PID=""
IP_24_PREFIX=10.12.230
AP_IP=${IP_24_PREFIX}.1
INVALID_PASS_CHARS="#/"

cd "$(dirname "$0")"
ORIGINAL_PWD=$(pwd)

if [ ! -f sae_pass ]; then
    echo "Missing password file for WPA3 password, cannot continue"
    exit 1
fi
if grep -qP '['${INVALID_PASS_CHARS}']' sae_pass; then
    echo "Password cannot contain '${INVALID_PASS_CHARS}'"
    exit 2
fi
sed -Ei "s/#(sae_password=)secret/\1$(cat sae_pass)/1" hostapd.conf

if [ ${STEAL_FROM_NM} -eq 1 ]; then
    echo "Taking ${AP_INTERFACE} from NetworkManger..."
    sudo nmcli dev set ${AP_INTERFACE} managed no
fi

echo "Clean up ${AP_INTERFACE} before using it..."
sudo ip link set ${AP_INTERFACE} down
sudo ip addr flush dev ${AP_INTERFACE}
echo "Disabling soft rfkill on ${WI_INDEX}..."
rfkill unblock ${WI_INDEX}
echo "Setting ${AP_IP}/24 on ${AP_INTERFACE}..."
sudo ip addr add ${AP_IP}/24 dev ${AP_INTERFACE}
sudo ip link set ${AP_INTERFACE} up

echo "Enable routing..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s ${IP_24_PREFIX}.0/24 -o ${INTERNET_INTERFACE} -j MASQUERADE
sudo iptables -A FORWARD -s ${IP_24_PREFIX}.0/24 -o ${INTERNET_INTERFACE} -j ACCEPT
sudo iptables -A FORWARD -d ${IP_24_PREFIX}.0/24 -m state --state ESTABLISHED,RELATED -i ${INTERNET_INTERFACE} -j ACCEPT

dnsmasq_args=(
    # No config file all will be configured with below options
    --conf-file=/dev/null
    # Disable DNS
    --port=0
    # Interface to run the DHCP server on
    --interface=${AP_INTERFACE}
    # Only listen to the specified interface
    --bind-interfaces
    # DHCP range
    --dhcp-range=${IP_24_PREFIX}.10,${IP_24_PREFIX}.50,12h
    # Alt DHCP lease file
    --dhcp-leasefile=/tmp/ap-dhcp-dnsmasq.leases
    # Alt PID file
    --pid-file=/tmp/ap-dhcp-dnsmasq.pid
    # Do not look for local dns
    --no-resolv
    # Should be the only DHCP on this subnet
    --dhcp-authoritative
    # Provide custom dns
    --dhcp-option=option:dns-server,208.67.222.123,208.67.220.123
)
echo "Starting dnsmasq daemon ..."
sudo dnsmasq ${dnsmasq_args[@]}

if [ ${LAUNCH_UXPLAY} -eq 1 ]; then
    echo "Launching uxplay for screen mirror..."
    cd ${UXPLAY_BUILD_DIR}
    stdbuf -oL -eL ./uxplay &> ${ORIGINAL_PWD}/uxplay.log < /dev/null &
    UXPLAY_PID=$!
fi
cd ${ORIGINAL_PWD}

echo "Starting hostapd..."
sudo hostapd -i ${AP_INTERFACE} ./hostapd.conf
echo "Hostapd stopped."

if [ ${LAUNCH_UXPLAY} -eq 1 ]; then
    echo "Killing uxplay for screen mirror..."
    kill -SIGINT ${UXPLAY_PID}
    wait ${UXPLAY_PID}
fi

echo "Start cleanup..."
sudo kill -SIGQUIT $(cat /tmp/ap-dhcp-dnsmasq.pid)
echo "Sent SIGQUIT to $(cat /tmp/ap-dhcp-dnsmasq.pid), waiting for it to close..."

echo "Bringing down ${AP_INTERFACE} and removing IPs..."
sudo ip link set ${AP_INTERFACE} down
sudo ip addr flush dev ${AP_INTERFACE}

if [ ${STEAL_FROM_NM} -eq 1 ]; then
    echo "Giving ${AP_INTERFACE} back to NetworkManger..."
    sudo nmcli dev set ${AP_INTERFACE} managed yes
fi

sed -Ei "s/^(sae_password=).+/#\1secret/1" hostapd.conf