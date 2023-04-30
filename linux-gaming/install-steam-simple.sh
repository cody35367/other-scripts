#!/bin/bash
../gnome/gen_desktop_file.py ./steam-simple.sh ~/.local/share/applications/steam-simple.desktop
echo "Icon=steam" >> ~/.local/share/applications/steam-simple.desktop
sed -i 's/Name=steam-simple/Name=Steam Simple/g' ~/.local/share/applications/steam-simple.desktop