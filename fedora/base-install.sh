#!/bin/bash
set -e
if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi

function usage(){
    echo \
"Usage: 
    $0 [-g|--gnome-ext] [-n|--nvidia] [-s|--ssh-keygen]
    
    -g|--gnome-ext      Open firefox to install the gnome extensions.
    -n|--nvidia         Install the nvidia driver.
    -s|--ssh-keygen     Generate SSH keys
    -h|--help           Display this menu.
                        
    Example:
        $0 --gnome-ext --nvidia --ssh-keygen"
}

INSTALL_GNOME_EXTENSIONS=0
INSTALL_NVIDIA=0
DO_SSH_KEYGEN=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -g|--gnome-ext)
        INSTALL_GNOME_EXTENSIONS=1
        shift
        ;;
        -n|--nvidia)
        INSTALL_NVIDIA=1
        shift
        ;;
        -s|--ssh-keygen)
        DO_SSH_KEYGEN=1
        shift
        ;;
        -h|--help)
        usage
        exit 0
        shift
        ;;
        -*|--*)
        echo "Error: Unsupported flag \"$1\""
        echo
        usage
        exit 1
        ;;
        *)
        echo "Error: Unsupported positional \"$1\""
        exit 2
        shift
        ;;
    esac
done

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update --refresh
sudo dnf install -y \
    chromium \
    vim \
    git \
    nmap \
    whois \
    gnome-tweaks \
    wireshark \
    fish \
    tilix \
    flameshot \
    curl \
    deja-dup \
    code \
    virt-manager \
    libvirt \
    vlc \
    ffmpeg \
    util-linux-user \
    java-11-openjdk \
    steam

sudo systemctl enable libvirtd --now

if [[ ${INSTALL_NVIDIA} == 1 ]]; then
    sudo dnf install -y akmod-nvidia
fi 

git config --global user.email "cody35367@gmail.com"
git config --global user.name "Cody Hodges"

sudo chsh -s /usr/bin/fish ${USER}
fish -c 'set -U fish_greeting'

if [[ ${DO_SSH_KEYGEN} == 1 ]]; then
    ssh-keygen
fi

if [[ ${INSTALL_GNOME_EXTENSIONS} == 1 ]]; then
    firefox https://extensions.gnome.org/extension/118/no-topleft-hot-corner/ &
    firefox https://extensions.gnome.org/extension/615/appindicator-support/ &
fi

cd "$(dirname "$0")"

mkdir -vp ~/Games ~/Downloads/installed
curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o ~/Downloads/installed/Minecraft.tar.gz
rm -rfv ~/Games/minecraft-launcher/
tar -xzf ~/Downloads/installed/Minecraft.tar.gz -C ~/Games

../gnome/set_backgrounds.sh
../gnome/create_startup_desktop_file.py ../gnome/brightness.sh
../gnome/create_startup_desktop_file.py ../gnome/custom_suspend.py
../gnome/gen_desktop_file.py ../linux-gaming/Minecraft.sh ~/.local/share/applications/Minecraft.desktop
