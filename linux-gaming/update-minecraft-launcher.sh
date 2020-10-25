#!/bin/bash

mkdir -vp ~/Games ~/Downloads/installed
# Minecraft
rm -rf ~/Games/minecraft-launcher/
curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o ~/Downloads/installed/Minecraft.tar.gz
tar -xzf ~/Downloads/installed/Minecraft.tar.gz -C ~/Games
../gnome/gen_desktop_file.py ./Minecraft.sh ~/.local/share/applications/Minecraft.desktop
