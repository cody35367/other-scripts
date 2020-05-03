# OKD Setup
Different methods for setting up OKD (sometimes OpenShift) on localhost.

https://github.com/openshift/okd
## Overview
- [CRC](#CRC)
- [Minishift](#Minishift)
- [libvirt](#libvirt)
- [oVirt](#oVirt)
    - [Install Client tools](#Install-Client-tools)
    - [Setup nested virtualization](#Setup-nested-virtualization)
    - [Setup oVirt as a VM](#Setup-oVirt-as-a-VM)
    - [Setup the OKD cluster](#Setup-the-OKD-cluster)
## CRC
- Used for OpenShift 4.X
    - https://github.com/code-ready/crc
- Releases
    - https://github.com/code-ready/crc/releases
- Docs
    - https://code-ready.github.io/crc/
- Setup
    - Go to (here)[https://cloud.redhat.com/openshift/install/crc/installer-provisioned] and setup a pull secret. 
    - Ensure `libvirt` and `NetworkManager` are installed.
    - Run the below to install `crc` bin `$PATH`
```bash
# Install
./install-crc-in-user-home.sh
# Remove
rm ~/.local/bin/crc ~/Downloads/installed/crc-linux-amd64.tar.xz
# Setup tool
crc setup
# Start a cluster
crc start
# For everything else.
crc -h
crc start -h
```
## Minishift
- Used for OpenShift 3.X
    - https://github.com/minishift/minishift
## libvirt
- Follow this:
    - https://github.com/openshift/okd/blob/master/Guides/UPI/libvirt/libvirt.md
## oVirt
- **!!THIS FAILED AND IS NOT WORKING!!**
- Kept for reference
- A guide for setting OKD on oVirt. oVirt will be setup as a VM and will use nested virtualization to host the OKD cluster. I have only tested this process on Fedora 32 Workstation.
### Install Client tools
Use the below script to install in your home directory.
```bash
# Install
./install-tools-in-user-home.sh
# Remove
rm ~/.local/bin/{kubectl,oc,openshift-install}
```
### Setup nested virtualization
Based the guide [here](https://docs.fedoraproject.org/en-US/quick-docs/using-nested-virtualization-in-kvm/). Run the below script to set this up.
```bash
./setup-nested-virtualization.sh
```
### Setup oVirt as a VM
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
        - Finish Deployment, will take a long time also.
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
### Setup the OKD cluster
1. Run `openshift-install create cluster` | **!!THIS FAILED AND IS NOT WORKING!!**
    - Select SSH public key
    - Platform: ovirt
    - Enter oVirt's api endpoint URL: https://ovirt-e/ovirt-engine/api
    - Is the installed oVirt certificate trusted (Y/n): n
    - Enter ovirt-engine username: press enter to use default admin@internal
    - Enter password: password setup under above Engine setup.
    - Select the oVirt cluster: Default
    - Select the oVirt storage domain: hosted_storage
    - Select the oVirt network: ovirtmgmt
    - Enter the internal API Virtual IP: 10.0.0.4
    - Enter the internal DNS Virtual IP: 10.0.0.5
    - Enter the ingress IP: 10.0.0.6
    - Base Domain: ovirt-net
    - Cluster Name: demo
    - Pull Secret: enter and leave blank.
