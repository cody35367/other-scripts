#!/bin/bash

set -e

SERVER_NAME="cnas1"
NAS_URL_PRE="smb://${SERVER_NAME}"
SHARE_NAME="homes"
VOLUME_MOUNT="/run/user/$(id -u)/gvfs/smb-share:server=${SERVER_NAME},share=${SHARE_NAME}"
REMOTE_VM_DIR="${VOLUME_MOUNT}/linux-home-backup"
BACKUP_LOG="${VOLUME_MOUNT}/linux-home-backup.log"
DIRS_TO_BACKUP=(
    ".thunderbird"
)

if [[ $(id -u) == 0 ]]; then
    echo "Do not run as sudo or root"'!'
    exit 1
fi

gio mount "${NAS_URL_PRE}/${SHARE_NAME}" || true

while [[ ! -d ${REMOTE_VM_DIR} ]]; do
    echo "${REMOTE_VM_DIR} not found or could not connect"'!'
    sleep 5
done

echo "$(date)| Backup started..." >> ${BACKUP_LOG}
for local_vm_dir in "${DIRS_TO_BACKUP[@]}"; do
    mkdir -pv "${REMOTE_VM_DIR}/${local_vm_dir}"
    rsync -rtv --delete --progress "${HOME}/${local_vm_dir}/" "${REMOTE_VM_DIR}/${local_vm_dir}"
done
sync
echo "$(date)| Backup completed successfully." >> ${BACKUP_LOG}
