#!/bin/bash

# Update and unzip
apt-get -y update && apt-get install -y unzip

# Install consul
cd /home/ubuntu
version='0.8.0'
wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -O consul.zip
unzip consul.zip
rm consul.zip

# Make consul executable
chmod +x consul
