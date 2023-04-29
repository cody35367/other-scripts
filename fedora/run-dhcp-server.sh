#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Please provide the interface name to listen on."
    exit 1
fi

sudo ip addr add 192.168.222.1/24 dev $1
sudo ip link set $1 up

# Only supported firewalld on Fedora for now. Other firewalls should be disabled or modified similarly.
if command -v firewall-cmd; then
    echo "Setting firewalld firewall to allow dhcp request in."
    sudo firewall-cmd --add-interface=$1
    sudo firewall-cmd --add-service=dhcp
fi

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
    --dhcp-range=192.168.222.10,192.168.222.50,12h
    # Alt DHCP lease file
    --dhcp-leasefile=/tmp/camera-dhcp-dnsmasq.leases
    # Alt PID file
    --pid-file=/tmp/camera-dhcp-dnsmasq.pid
    # Do not look for local dns
    --no-resolv
    # Should be the only DHCP on this subnet
    --dhcp-authoritative
)

sudo dnsmasq ${args[@]}

if command -v firewall-cmd; then
    sudo firewall-cmd --reload
fi
sudo ip link set $1 down
sudo ip addr del 192.168.222.1/24 dev $1
echo "Clean up complete."
