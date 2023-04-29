#!/bin/bash
set -e
#set -x
if [[ -z $1 ]]; then
    echo "Missing arg! Please supply env file."
    exit 1
fi
. $1
"$(dirname "$0")/run-and-email.py" -s "${JOB_SUBJECT}" -t ${JOB_TO} "rclone sync ${RCLONE_OPTIONS} ${RCLONE_SOURCE} ${RCLONE_DESTINATION}"