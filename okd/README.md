# OKD Setup
A guide for setting OKD on oVirt. oVirt will be setup as a VM and will use nested virtualization to host the OKD cluster. I have only tested this process on Fedora 32 Workstation.
## Overview
- [Install Client tools](#Install-Client-tools)
- [Setup nested virtualization](#Setup-nested-virtualization)
- [Setup oVirt as a VM](#Setup-oVirt-as-a-VM)
- [Setup the OKD cluster](#Setup-the-OKD-cluster)
## Install Client tools
Use the below script to install in your home directory.
```bash
./install-tools-in-user-home.sh
```
## Setup nested virtualization
Based the guide [here](https://docs.fedoraproject.org/en-US/quick-docs/using-nested-virtualization-in-kvm/). Run the below script to set this up.
```bash
./setup-nested-virtualization.sh
```
## Setup oVirt as a VM
1. Download the latest oVirt stable [here](https://www.ovirt.org/download/node.html).
2. Setup the libvirt+KVM VM in virt-manager. Be sure to follow the setup notes [here](https://docs.fedoraproject.org/en-US/quick-docs/using-nested-virtualization-in-kvm/#proc_configuring-nested-virtualization-in-virt-manager) when setting up the virtual CPU. Allocated 4 CPUs, 10 GB of RAM, 120 GB of storage. Use the below to Backup/Restore VM config (not virtual disk).
```bash
# How I backed up (included in this repo)
sudo virsh dumpxml ovirt-vm > ./ovirt-vm.xml
sudo virsh net-dumpxml ovirt-net > ./ovirt-net.xml
# Restore
sudo virsh define ./ovirt-vm.xml
sudo virsh net-destroy ovirt-net
sudo virsh net-define ./ovirt-net.xml
sudo virsh net-start ovirt-net
```
3. Boot the ISO into the installer.
4. Run through the installer.
    - Set language and keyboard layout
    - Set timezone
    - Set keyboard layout again
    - Set hostname
    - Connect to network
    - Partition LVM Thin Provision
        - 1020 MiB /boot vda1
        - 75.16 GiB / onn_ovirt-root
        - 15 GiB /var onn_ovirt-var
        - 5056 MiB swap onn_ovirt_swap
    - Only set a root password
5. Once the VM comes up from reboot, login to tty. Do the following:
```bash
# On physical host
sudo firewall-cmd --add-port 8000/tcp --zone libvirt
python3 -m http.server
# On ovirt VM
curl 10.0.0.1:8000/setup-ovirt-host.sh -o setup-ovirt-host.sh
chmod u+x setup-ovirt-host.sh
./setup-ovirt-host.sh
```
6. Go to https://10.0.0.2:9090/ login with root account, navigate to Virtualization -> Start under Hosted Engine to setup.
    - VM
        - Engine VM FQDN: ovirt-e
        - MAC Address: 52:54:00:00:00:02
        - Network Configuration: DHCP
        - Bridge Interface: eth0
        - Root Password: \<whatever>
        - Root SSH Access: Yes
        - Number of Virtual CPUs: 2
        - Memory Size (MiB) 4096
    - Engine
        - Admin Portal Password: \<whatever>
        - Notification/Email Settings: leave default
    - Prepare VM
        - Run the prepare, will take a long time.
    - Storage
        - Storage Type: NFS
        - Storage Connection: 10.0.0.2:/nfs
    - Finish
        - Finish Deployment
7. Edit physical hosts file to map from `10.0.0.3 ovirt-e`
8. Go to https://ovirt-e/ovirt-engine/
    - Login: https://ovirt-e/ovirt-engine/sso/login.html
        - admin
        - password setup under above Engine setup.
    - Administration Portal: https://ovirt-e/ovirt-engine/webadmin/
    - VM Portal: https://ovirt-e/ovirt-engine/web-ui/
    - REST API: https://ovirt-e/ovirt-engine/api/
        - admin@internal
        - password setup under above Engine setup.
## Setup the OKD cluster