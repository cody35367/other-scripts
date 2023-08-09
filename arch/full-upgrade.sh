#!/bin/bash
set -e
if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi
sudo pacman -Syu --noconfirm
if [[ -x "$(command -v yay)" ]]; then
  yay -Syu --noconfirm
fi
echo
echo "Installed foreign packages:"
pacman -Qqm | true
echo
echo
"$(dirname "$0")/../linux-general/update-vscode.sh"
"$(dirname "$0")/../linux-gaming/update-discord.sh"
"$(dirname "$0")/../linux-gaming/update-minecraft-launcher.sh"
