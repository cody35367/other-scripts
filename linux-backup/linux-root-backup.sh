#!/bin/bash

set -e

SERVER_NAME="cnas1"
NAS_URL_PRE="smb://${SERVER_NAME}"
SHARE_NAME="home"
VOLUME_MOUNT="/run/user/$(id -u)/gvfs/smb-share:server=${SERVER_NAME},share=${SHARE_NAME}"
REMOTE_VM_DIR="${VOLUME_MOUNT}/linux-root-backup"
BACKUP_LOG="${VOLUME_MOUNT}/linux-root-backup.log"
DIRS_TO_BACKUP=(
    "/etc/libvirt"
    "/var/lib/libvirt/images"
)
ACL_TRACKER_FILE="${HOME}/linux-root-backup-acl-tracker"

if [[ $(id -u) == 0 ]]; then
    echo "Do not run as sudo or root"'!'
    exit 1
fi

if [[ -f ${ACL_TRACKER_FILE} ]]; then
    echo "Will not continue, ACL tracker file still exists."
    echo "Please restore the below to continue:"
    echo "      sudo setfacl --restore=${ACL_TRACKER_FILE} && rm ${ACL_TRACKER_FILE}"
    exit 1
fi

gio mount "${NAS_URL_PRE}/${SHARE_NAME}" || true

while [[ ! -d ${REMOTE_VM_DIR} ]]; do
    echo "${REMOTE_VM_DIR} not found or could not connect"'!'
    sleep 5
done

echo "$(date)| Backup started..." >> ${BACKUP_LOG}
for local_vm_dir in "${DIRS_TO_BACKUP[@]}"; do
    sudo getfacl -pR ${local_vm_dir} > ${ACL_TRACKER_FILE}
    sudo setfacl -Rm "u:$(id -u -n):rx" ${local_vm_dir}
    mkdir -pv "${REMOTE_VM_DIR}${local_vm_dir}"
    rsync -rtv --delete --progress "${local_vm_dir}/" "${REMOTE_VM_DIR}${local_vm_dir}"
    sudo setfacl --restore=${ACL_TRACKER_FILE}
done
sync
echo "$(date)| Backup completed successfully." >> ${BACKUP_LOG}
rm ${ACL_TRACKER_FILE}
