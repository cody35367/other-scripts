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
2. Setup the libvirt+KVM VM in virt-manager. Be sure to follow the setup notes [here](https://docs.fedoraproject.org/en-US/quick-docs/using-nested-virtualization-in-kvm/#proc_configuring-nested-virtualization-in-virt-manager) when setting up the virtual CPU. Allocated 4 CPUs, 10 GB of RAM, 100 GB of storage.
3. Boot the ISO into the installer.
4. Run through the installer.
    - set hostname
    - connect to network
    - Partition 10 GB Swap, / remaining
    - only set a root password
5. Once the VM comes up from reboot, login to tty. Do the following:
    - ```bash
      # On physical host
      python3 -m http.server
      # On ovirt VM
      curl 10.0.0.1/setup-ovirt-host.sh -o setup-ovirt-host.sh
      chmod u+x setup-ovirt-host.sh
      ./setup-ovirt-host.sh
      ```
6. Login with root account, navigate to Virtualization -> Start under Hosted Engine to setup.
    - 

Backup/Restore VM config (not virtual disk).
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
## Setup the OKD cluster