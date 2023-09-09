#!/bin/bash
set -e

ENABLE_AUR_UPDATES=1
ENABLE_HOME_APPS_UPDATE=1
ENABLE_TIMESHIFT_BACKUP=1

if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi
if [[ ${ENABLE_TIMESHIFT_BACKUP} == 1 ]]; then
  if [[ -x "$(command -v timeshift)" ]]; then
    SYSTEM_UPDATE_COMMENT="before system update"
    SYSTEM_BACKUPS=$(sudo timeshift --list | grep "${SYSTEM_UPDATE_COMMENT}" | awk '{ print $3 }')
    for backup in $(echo "${SYSTEM_BACKUPS}" | head -n -2); do # head -n -2 is all but last 2 snapshots (this new one being a 3rd)
      sudo timeshift --delete --snapshot ${backup}
    done
    sync
    sudo timeshift --create --comments "${SYSTEM_UPDATE_COMMENT}"
    sync
  fi
fi
sudo pacman -Syu --noconfirm
if [[ ${ENABLE_AUR_UPDATES} == 1 ]]; then
  # yay
  if [[ -x "$(command -v yay)" ]]; then
    yay -Syu --noconfirm
  fi
  # paru
  if [[ -x "$(command -v paru)" ]]; then
    paru -Syu --noconfirm
  fi
fi
echo
echo "Installed foreign packages:"
pacman -Qqm | true
echo
echo
if [[ ${ENABLE_HOME_APPS_UPDATE} == 1 ]]; then
  "$(dirname "$0")/../linux-general/update-vscode.sh"
  "$(dirname "$0")/../linux-gaming/update-discord.sh"
  "$(dirname "$0")/../linux-gaming/update-minecraft-launcher.sh"
fi