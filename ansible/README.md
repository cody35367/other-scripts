# Ansible

## Setup
```bash
# Install ansible on localhost
./install-ansible.sh
# Copy over ssh keys and setup password less sudo
./setup-host.sh 192.168.125.12
```

## Setup ZFS
```bash
ansible-playbook -i ./hi-clan.yml ./pb-centos8-zfs.yml
ssh 192.168.125.12
sudo zpool create zpool1 mirror -m /data/zpool1 -o ashift=12 /dev/disk/by-id/ata-WDC_WD10EZEX-08WN4A0_WD-WCC6Y5HA8SN5 /dev/disk/by-id/ata-WDC_WD1003FZEX-00MK2A0_WD-WCC3F5THHV0D
sudo zfs set xattr=sa zpool1
```

## Setup Samaba
```bash
ansible-playbook -i ./hi-clan.yml ./pb-centos8-samba.yml
ssh 192.168.125.12
sudo smbpasswd -a cody
sudo smbpasswd -a corinne
sudo vim /etc/hosts
    # Add clin2 and clin2.clan to 127.0.0.1
```