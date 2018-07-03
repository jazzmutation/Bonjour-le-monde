#!/bin/bash
bash 2>&1 <<"USERDATA" | while read line; do echo "$(date --iso-8601=ns) $line"; done | tee -a /var/log/userdata.log
set -xe

# Place commands in this script to customise the EC2 instance at launch time.
HOST_NAME=$(hostname -f)
echo "This is a dummy line to test logging on ${HOST_NAME}" 

USERDATA
