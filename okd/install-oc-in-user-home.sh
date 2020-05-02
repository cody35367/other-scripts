#!/bin/bash

USER_HOME_BIN_PATH="${HOME}/.local/bin/"
USER_DOWNLOADS_DIR="${HOME}/Downloads/installed/"
OC_DOWNLOAD_URL="https://github.com/openshift/okd/releases/download/4.4.0-0.okd-2020-04-21-163702-beta4/openshift-client-linux-4.4.0-0.okd-2020-04-21-163702-beta4.tar.gz"
OC_DOWNLOAD_FILE="openshift-client-linux-4.4.0-0.okd-2020-04-21-163702-beta4.tar.gz"

mkdir -pv ${USER_DOWNLOADS_DIR}
curl -L ${OC_DOWNLOAD_URL} -o ${USER_DOWNLOADS_DIR}${OC_DOWNLOAD_FILE}
tar -xzf ${USER_DOWNLOADS_DIR}${OC_DOWNLOAD_FILE} -C ${USER_HOME_BIN_PATH} oc kubectl