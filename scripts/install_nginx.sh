#!/bin/bash

echo "Updating Server"
sudo yum update -y

echo "Install NGINX"
sudo yum install nginx -y

echo "Nginx installation Complete"
