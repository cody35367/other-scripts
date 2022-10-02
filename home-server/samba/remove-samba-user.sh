#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Must provide the username."
    exit 1
fi

HOME_DIR_BASE="/p1/shares/"

sudo smbpasswd -x $1
sudo userdel $1
echo "Remember to delete the home dir at ${HOME_DIR_BASE}%1 if you are done with it."
