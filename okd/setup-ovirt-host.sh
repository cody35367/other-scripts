#!/bin/bash

# Show virtualization capabilities
virt-host-validate

find_string="10.0.0.3 ovirt-e"
if ! grep -qF "${find_string}" /etc/hosts; then
    echo "${find_string}" >> /etc/hosts
fi

# NFS
mkdir -pv /nfs
chown nfsnobody:nfsnobody /nfs
chmod 755 /nfs
echo "/nfs *(rw,all_squash)" > /etc/exports
firewall-cmd --add-service nfs
firewall-cmd --add-service nfs --permanent
systemctl enable nfs --now