#!/bin/bash
set -e
if [[ -z $1 ]]; then
    echo "Missing arg! Please supply env file."
    exit 1
fi
. $1
./run-and-email.py "rclone sync ${RCLONE_OPTIONS} ${RCLONE_SOURCE} ${RCLONE_DESTINATION}"