#!/bin/bash
sudo apt update
sudo apt full-upgrade
sudo apt autoremove
if [ -f /var/run/reboot-required ]; then
  echo 'Reboot required for the following:'
  cat /var/run/reboot-required.pkgs
fi
