#!/bin/bash

set -e

function usage(){
    echo "Usage: $0 [external_interface_name] [internal_gateway_ip]"
}

if [[ $# -ne 2 ]]; then
    echo "Expecting two arguments only!"
    usage
    exit 1
fi

sudo sysctl -w net.ipv4.ip_forward=1
sudo bash -c 'echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/ip_forward.conf'
# Do not allow any services in through the external zone.
for srv in $(sudo firewall-cmd --list-services --permanent --zone external); do
    sudo firewall-cmd --remove-service=${srv} --permanent --zone external
done
sudo firewall-cmd --change-interface=$1 --zone=external --permanent
sudo firewall-cmd --add-masquerade --zone=external --permanent
sudo firewall-cmd --set-default-zone=internal
sudo firewall-cmd --add-service=dns --zone=internal --permanent
sudo firewall-cmd --complete-reload
sudo bash -c 'echo -e "[main]\ndns=dnsmasq" > /etc/NetworkManager/conf.d/enable-dnsmasq.conf'
sudo bash -c 'echo listen-address=127.0.0.1,'$2' > /etc/NetworkManager/dnsmasq.d/listen-local-gateway.conf'
sudo systemctl restart NetworkManager
