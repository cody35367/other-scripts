#!/bin/bash

RUN_LOG=/tmp/startup-script.sh.log

echo "[$(date '+%F %T %Z')]: Script start" > ${RUN_LOG}
echo "[$(date '+%F %T %Z')]: Script finish" >> ${RUN_LOG}