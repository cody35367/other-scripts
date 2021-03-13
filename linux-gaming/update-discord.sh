#!/bin/bash

mkdir -vp ~/Applications ~/Downloads/installed
# Minecraft
rm -rf ~/Applications/Discord/
curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o ~/Downloads/installed/Discord.tar.gz
tar -xzf ~/Downloads/installed/Discord.tar.gz -C ~/Applications
../gnome/gen_desktop_file.py ./Discord.sh ~/.local/share/applications/Discord.desktop
