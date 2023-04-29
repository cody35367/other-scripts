#!/bin/bash

set -e
cd "$(dirname "$0")"

USER_SYSTEMD_DIR=${HOME}/.config/systemd/user/

mkdir -p ${USER_SYSTEMD_DIR}

cp ./linux-home-backup.service ${USER_SYSTEMD_DIR}
cp ./linux-home-backup.timer ${USER_SYSTEMD_DIR}

systemctl --user daemon-reload

systemctl --user enable --now linux-home-backup.timer
