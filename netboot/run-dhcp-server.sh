#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Please provide the interface name to listen on and interface to route through."
    exit 1
fi

sudo ip addr add 192.168.213.1/24 dev $1
sudo ip link set $1 up

# Only supported firewalld on Fedora for now. Other firewalls should be disabled or modified similarly.
if command -v firewall-cmd; then
    echo "Setting firewalld firewall to allow dhcp request in."
    sudo firewall-cmd --add-interface=$1
    sudo firewall-cmd --add-service=dhcp
fi

sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 192.168.213.0/24 -o $2 -j MASQUERADE
sudo iptables -A FORWARD -s 192.168.213.0/24 -o $2 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.213.0/24 -m state --state ESTABLISHED,RELATED -i $2 -j ACCEPT

args=(
    # No config file all will be configured with below options
    --conf-file=/dev/null
    # Run in the foreground with debug mode
    --no-daemon
    # Disable DNS
    --port=0
    # Interface to run the DHCP server on
    --interface=$1
    # Only listen to the specified interface
    --bind-interfaces
    # DHCP range
    --dhcp-range=192.168.213.10,192.168.213.50,12h
    # Alt DHCP lease file
    --dhcp-leasefile=/tmp/local-dhcp-dnsmasq.leases
    # Alt PID file
    --pid-file=/tmp/local-dhcp-dnsmasq.pid
    # Do not look for local dns
    --no-resolv
    # Should be the only DHCP on this subnet
    --dhcp-authoritative
    # Provide DNS
    --dhcp-option=6,1.1.1.1,8.8.8.8
    # TFTP Info to point to netboot.xyz
    --dhcp-match=set:efi64,60,PXEClient:Arch:00007
    --dhcp-boot=tag:efi64,netboot.xyz.efi,,192.168.213.1
)

# Uncomment if you need to only pull images locally, otherwise we can just pull it from the project's github
#echo -e '#!ipxe\nset live_endpoint http://192.168.213.1:8080' > config/menus/local-vars.ipxe

sudo dnsmasq ${args[@]}

if command -v firewall-cmd; then
    sudo firewall-cmd --reload
fi
sudo ip link set $1 down
sudo ip addr del 192.168.213.1/24 dev $1
echo "Clean up complete."
