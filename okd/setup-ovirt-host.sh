#!/bin/bash

# Show virtualization capabilities
virt-host-validate

# NFS
mkdir /nfs
chown nfsnobody:nfsnobody /nfs
chmod 755 /nfs
echo "/nfs *(rw,all_squash)" > /etc/exports
firewall-cmd --add-service nfs
firewall-cmd --add-service nfs --permanent
systemctl enable nfs --now