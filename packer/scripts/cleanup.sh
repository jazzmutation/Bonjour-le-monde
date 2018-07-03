#!/usr/bin/env bash
set -xe

echo "Cleaning up..."
yum clean all
rm -rf /tmp/*
rm -rf /ops

echo "Disable sshd service for security reasons"
systemctl disable sshd.service
