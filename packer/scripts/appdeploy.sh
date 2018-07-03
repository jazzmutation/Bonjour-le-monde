#!/usr/bin/env bash
set -e

echo "Configure the application and required services - Nginx, Unicorn etc"

# Nginx configuration
cp /ops/srcdir/ngunicorn.conf /etc/nginx/conf.d/
cp /ops/srcdir/nginx.conf /etc/nginx/
systemctl enable nginx.service

# Unicorn systemd configuration
cp /ops/srcdir/unicorn.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable unicorn.service

# Setup simple sinatra app
mkdir /var/www
tar -xvf /ops/srcdir/simple-sinatra-app.tar -C /var/www

echo "End of application deployment configuration"
