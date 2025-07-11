# 20250710 Setup Notes
- Add the following to ~/.bashrc
```bash
# Add ~/.local/bin to PATH if it's not already there and the directory exists
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
```
- Run BDO Launch Options in Steam
```shell
rm "/home/chodges/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Black Desert Online/bin64/XignCode/NA/1/xmag_x64.xem"; %command%
```
- Things I installed and setup
```bash
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
pacman -Sy sudo vim gnome firefox podman distrobox power-profiles-daemon git flatpak bind gnome-shell-extension-appindicator gamemode fwupd bluez networkmanager
vim /etc/locale.gen
# Uncomment en_US.UTF-8 UTF-8
locale-gen
vim /etc/locale.conf
# LANG=en_US.UTF-8
vim /etc/hostname
# Give it a hostname
mkinitcpio -P
bootctl install
cd /boot/loader/entries
vim arch.conf
# title   Arch Linux
# linux   /vmlinuz-linux
# initrd  /initramfs-linux.img
# options root=UUID=<UUID> rw
cp arch.conf arch-fallback.conf
vim arch-fallback.conf
# Replace UUID
useradd -c "Cody Hodges" -G wheel -m -s /bin/bash -U chodges
passwd chodges
vim /etc/sudoers
# Uncomment %wheel ALL=(ALL:ALL) ALL
# Now you su to chodges user
sudo systemctl enable gdm
sudo systemctl enable NetworkManager
# Create a distrobox and then install vscode and do this in the container
distrobox-export --app code
distrobox-export --bin /usr/bin/code
```
# Things to look at versioning in the future
- ~/.bashrc
- ~/.gitconfig
- Vscode user settings