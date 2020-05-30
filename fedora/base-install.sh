#!/bin/bash
set -e
if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi

function usage(){
    echo \
"Usage: 
    $0 [--gnome] [--nvidia] [--ssh-keygen] [--gaming] [-a|--all]
    
    --gnome          Setup and install things related to gnome.
    --nvidia         Install the nvidia driver.
    --ssh-keygen     Generate SSH keys
    --gaming            Install gaming stuff like steam and Minecraft
    -a|--all            Install all the above.
    -h|--help           Display this menu.
                        
    Example:
        $0 --gnome-ext --nvidia --ssh-keygen
        $0 --all"
}

GNOME_SETUP=0
INSTALL_NVIDIA=0
DO_SSH_KEYGEN=0
INSTALL_GAMING=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --gnome)
            GNOME_SETUP=1
            shift
        ;;
        --nvidia)
            INSTALL_NVIDIA=1
            shift
        ;;
        --ssh-keygen)
            DO_SSH_KEYGEN=1
            shift
        ;;
        --gaming)
            INSTALL_GAMING=1
            shift
        ;;
        -a|--all)
            GNOME_SETUP=1
            INSTALL_NVIDIA=1
            DO_SSH_KEYGEN=1
            INSTALL_GAMING=1
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

cd "$(dirname "$0")"

sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install -y \
    vim \
    git \
    gitk \
    git-gui \
    nmap \
    whois \
    wireshark \
    fish \
    tilix \
    flameshot \
    curl \
    code \
    virt-manager \
    libvirt \
    vlc \
    ffmpeg \
    util-linux-user \
    buildah \
    toolbox \
    npm \
    htop
sudo dnf install -y https://nmap.org/dist/zenmap-7.80-1.noarch.rpm

sudo systemctl enable libvirtd --now
git config --global user.email "cody35367@gmail.com"
git config --global user.name "Cody Hodges"
sudo chsh -s /usr/bin/fish ${USER}
fish -c 'set -U fish_greeting'

if [[ ${INSTALL_NVIDIA} == 1 ]]; then
    sudo dnf install -y akmod-nvidia
fi 

if [[ ${DO_SSH_KEYGEN} == 1 ]]; then
    ssh-keygen
fi

if [[ ${GNOME_SETUP} == 1 ]]; then
    sudo dnf install -y \
        gnome-tweaks \
        deja-dup
    ../gnome/set_backgrounds.sh
    ../gnome/create_startup_desktop_file.py ../gnome/brightness.sh
    ../gnome/create_startup_desktop_file.py ../gnome/custom_suspend.py
    ../gnome/gen_desktop_file.py ../linux-gaming/Minecraft.sh ~/.local/share/applications/Minecraft.desktop
    firefox https://extensions.gnome.org/extension/118/no-topleft-hot-corner/ &
    firefox https://extensions.gnome.org/extension/615/appindicator-support/ &
fi

if [[ ${INSTALL_GAMING} == 1 ]]; then
    sudo dnf install -y \
        java-11-openjdk \
        steam
    mkdir -vp ~/Games ~/Downloads/installed
    curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o ~/Downloads/installed/Minecraft.tar.gz
    rm -rfv ~/Games/minecraft-launcher/
    tar -xzf ~/Downloads/installed/Minecraft.tar.gz -C ~/Games
fi

mkdir -pv ~/.local/bin
if ! fish -c 'echo $fish_user_paths' | grep -q ${HOME}/.local/bin; then
    fish -c 'set -Up fish_user_paths ~/.local/bin'
fi
fish -c 'fish_update_completions'
