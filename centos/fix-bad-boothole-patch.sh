#!/bin/bash
set -e

sudo dnf clean all
sudo dnf reinstall -y shim\* grub2\* mokutil
