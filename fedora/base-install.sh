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
    
    --gnome             Setup and install things related to gnome.
    --nvidia            Install the nvidia driver.
    --ssh-keygen        Generate SSH keys
    --gaming            Install gaming stuff like steam and Minecraft. Will also enable gnome setup (--gnome).
    --skip_prompt       Skip any press any key to continue prompts.
    -a|--all            Install all the above. Does not include Alienware laptop stuff, need to add that option if needed.s
    -h|--help           Display this menu.
                        
    Example:
        $0 --gnome-ext --nvidia --ssh-keygen
        $0 --all"
}

GNOME_SETUP=0
INSTALL_NVIDIA=0
DO_SSH_KEYGEN=0
INSTALL_GAMING=0
SKIP_PROMPT=0

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
            GNOME_SETUP=1
            shift
        ;;
        --skip_prompt)
            SKIP_PROMPT=1
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
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y \
    vim \
    git \
    gitk \
    git-gui \
    nmap \
    whois \
    wireshark \
    tilix \
    curl \
    code \
    virt-manager \
    libvirt \
    vlc \
    ffmpeg \
    util-linux-user \
    buildah \
    toolbox \
    htop
sudo dnf install -y https://nmap.org/dist/zenmap-7.80-1.noarch.rpm

sudo systemctl enable libvirtd --now
sudo usermod -a -G libvirt ${USER}
git config --global user.email "cody35367@gmail.com"
git config --global user.name "Cody Hodges"

if [[ ${INSTALL_NVIDIA} == 1 ]]; then
    if [[ ${SKIP_PROMPT} == 0 ]]; then
        read -p "Please enable rpmfusion-nonfree-nvidia-driver in the gnome store and then press any key to continue..."
    fi
    sudo dnf install -y akmod-nvidia
fi 

if [[ ${DO_SSH_KEYGEN} == 1 ]]; then
    ssh-keygen
fi

if [[ ${GNOME_SETUP} == 1 ]]; then
    sudo dnf install -y \
        gnome-tweaks \
        deja-dup \
        xdotool \
        gnome-shell-extension-appindicator \
    ../gnome/set_backgrounds.sh
    xdotool key "Alt+F2+r" && sleep 0.5 && xdotool key "Return" && sleep 10
    echo "Note on wayland, the restart of gnome does not work. If on wayland, you must log out and back in (not checked)."
    gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
    if [[ ${INSTALL_GAMING} == 1 ]]; then
        if [[ ${SKIP_PROMPT} == 0 ]]; then
            read -p "Please enable rpmfusion-nonfree-steam in the gnome store and then press any key to continue..."
        fi
        sudo dnf install -y \
            java-11-openjdk \
            steam \
            gamemode \
            gnome-shell-extension-gamemode
        mkdir -vp ~/Games ~/Downloads/installed ~/Applications
        # Minecraft
        if [[ ! -d ~/Games/minecraft-launcher/ ]]; then
            curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o ~/Downloads/installed/Minecraft.tar.gz
            tar -xzf ~/Downloads/installed/Minecraft.tar.gz -C ~/Games
        fi
        ../gnome/gen_desktop_file.py ../linux-gaming/Minecraft.sh ~/.local/share/applications/Minecraft.desktop
        # Discord
        if [[ ! -d ~/Applications/Discord/ ]]; then
            curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o ~/Downloads/installed/Discord.tar.gz
            tar -xzf ~/Downloads/installed/Discord.tar.gz -C ~/Applications
        fi
        ../gnome/gen_desktop_file.py ../linux-gaming/Discord.sh ~/.local/share/applications/Discord.desktop
        # Gamemode extension
        gnome-extensions enable gamemode@christian.kellner.me
    fi
    echo "If extensions are not working, open gnome-tweaks and enabled Extensions (topbar)."
fi

mkdir -pv ~/.local/bin