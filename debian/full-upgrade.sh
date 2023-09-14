#!/bin/bash
set -e
if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi

. /etc/os-release

sudo apt update
sudo apt full-upgrade -y
sudo apt -t ${VERSION_CODENAME}-backports full-upgrade -y
sudo apt autoremove -y
if [ -f /var/run/reboot-required ]; then
  echo
  echo 'Reboot required for the following:'
  cat /var/run/reboot-required.pkgs
fi
