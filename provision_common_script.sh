#!/bin/bash

# 0. Load Params
# source /vagrant/params.sh

# 1. Install base packages
apt-get update
apt-get install -y bats mc docker.io

# 2. Enable Docker
systemctl enable docker.service
systemctl start docker.service

# 3. Add hosts entries
cat /vagrant/hosts >> /etc/hosts
