#!/bin/bash
set -e
if [[ ! -z ${SUDO_USER} ]]; then
  echo "Please do not run as sudo!"
  exit 1
fi
sudo dnf upgrade --refresh -y