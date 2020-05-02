#!/bin/bash

set -e

USER_HOME_BIN_PATH="${HOME}/.local/bin/"
USER_DOWNLOADS_DIR="${HOME}/Downloads/installed/"
LATEST_OC_DOWNLOAD_URL="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
LATEST_OC_DOWNLOAD_FILE="oc.tar.gz"
REGISTRY_URL="quay.io/openshift/okd:4.4.0-0.okd-2020-04-21-163702-beta4"

mkdir -pv ${USER_DOWNLOADS_DIR}
curl -L ${LATEST_OC_DOWNLOAD_URL} -o ${USER_DOWNLOADS_DIR}${LATEST_OC_DOWNLOAD_FILE}
tar -xzf ${USER_DOWNLOADS_DIR}${LATEST_OC_DOWNLOAD_FILE} -C ${USER_HOME_BIN_PATH} oc
cd ${USER_DOWNLOADS_DIR}
oc adm release extract --tools ${REGISTRY_URL}
if ! sha256sum -c ./sha256sum.txt; then
    echo "Error verifying checksums."
    exit 1
fi
CURRENT_RELEASE_CLIENT_TAR=$(cat ./sha256sum.txt | awk '{print $2}' | grep client)
CURRENT_RELEASE_INSTALL_TAR=$(cat ./sha256sum.txt | awk '{print $2}' | grep install)
rm -v ./sha256sum.txt ./release.txt
echo
echo "Installed the following in \"${USER_HOME_BIN_PATH}\":"
tar -xvzf ${USER_DOWNLOADS_DIR}${CURRENT_RELEASE_CLIENT_TAR} -C ${USER_HOME_BIN_PATH} oc kubectl
tar -xvzf ${USER_DOWNLOADS_DIR}${CURRENT_RELEASE_INSTALL_TAR} -C ${USER_HOME_BIN_PATH} openshift-install

echo
echo "oc version --client:"
echo "  $(oc version --client)"
echo "kubectl version --client:"
echo "  $(kubectl version --client)"
echo "openshift-install version:"
output=$(openshift-install version)
echo "  ${output//$'\n'/$'\n'  }"
echo
