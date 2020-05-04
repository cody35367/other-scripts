#!/bin/bash

set -e

USER_HOME_BIN_PATH="${HOME}/.local/bin/"
USER_DOWNLOADS_DIR="${HOME}/Downloads/installed/"
CRC_DOWNLOAD_URL="https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz"
CRC_CHECKSUM_URL="https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/sha256sum.txt"
CRC_TAR_PATHS=("crc-linux-*-amd64/crc")
CRC_DOWNLOAD_FILE="crc-linux-amd64.tar.xz"
CRC_CHECKSUM_FILE="sha256sum.txt"

mkdir -pv ${USER_DOWNLOADS_DIR}
if [[ ! -f ${USER_DOWNLOADS_DIR}${CRC_DOWNLOAD_FILE} || $1 == "-r" ]]; then
    curl ${CRC_DOWNLOAD_URL} -o ${USER_DOWNLOADS_DIR}${CRC_DOWNLOAD_FILE}
fi
curl ${CRC_CHECKSUM_URL} -o ${USER_DOWNLOADS_DIR}${CRC_CHECKSUM_FILE}
cd "${USER_DOWNLOADS_DIR}"
if ! sha256sum --ignore-missing -c "./${CRC_CHECKSUM_FILE}"; then
    echo "Error verifying checksums."
    exit 1
fi
rm -v "./${CRC_CHECKSUM_FILE}"
tar -xvf ${USER_DOWNLOADS_DIR}${CRC_DOWNLOAD_FILE} --strip-components=1 -C ${USER_HOME_BIN_PATH} ${CRC_TAR_PATHS[@]}

echo
echo "crc version:"
output=$(crc version)
echo "  ${output//$'\n'/$'\n'  }"
