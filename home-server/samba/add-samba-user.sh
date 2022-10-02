#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Must provide the username."
    exit 1
fi

HOME_DIR_BASE="/p1/shares/"
COMMON_GROUPS="family"

sudo useradd -m -b ${HOME_DIR_BASE}$1 -G ${COMMON_GROUPS} -s /bin/bash -U $1
sudo smbpasswd -a $1
