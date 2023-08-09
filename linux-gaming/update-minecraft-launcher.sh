#!/bin/bash

mkdir -vp ~/Games ~/Downloads/installed
# Minecraft
rm -rf ~/Games/minecraft-launcher/
curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o ~/Downloads/installed/Minecraft.tar.gz
tar -xzf ~/Downloads/installed/Minecraft.tar.gz -C ~/Games
"$(dirname "$0")/../gnome/gen_desktop_file.py" "$(dirname "$0")/Minecraft.sh" ~/.local/share/applications/Minecraft.desktop
