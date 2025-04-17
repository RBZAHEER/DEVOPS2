#!/bin/bash

echo "Starting NGINX"
sudo systemctl start nginx
sudo systemctl enable nginx

echo "NGINX is now active"
