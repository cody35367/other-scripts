#!/bin/bash

set -e

USER_HOME_BIN_PATH="${HOME}/.local/bin/"
USER_DOWNLOADS_DIR="${HOME}/Downloads/installed/"
LATEST_OC_DOWNLOAD_URL="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
LATEST_OC_DOWNLOAD_FILE="oc.tar.gz"

mkdir -pv ${USER_DOWNLOADS_DIR}
curl -L ${LATEST_OC_DOWNLOAD_URL} -o ${USER_DOWNLOADS_DIR}${LATEST_OC_DOWNLOAD_FILE}
tar -xzf ${USER_DOWNLOADS_DIR}${LATEST_OC_DOWNLOAD_FILE} -C ${USER_HOME_BIN_PATH} oc
