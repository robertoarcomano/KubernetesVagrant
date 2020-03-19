#!/bin/bash

# 0. Load Params
# source /vagrant/params.sh

# 1. Install all packages
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cp /vagrant/kubernetes.list /etc/apt/sources.list.d

apt-get update
apt-get install -y bats mc docker.io apt-transport-https kubeadm kubelet kubectl

# 2. Enable Docker
systemctl enable docker.service
systemctl start docker.service

# 3. Add hosts entries
cat /vagrant/hosts >> /etc/hosts

# 4. Copy SSH Keys
SSH_PATH=/root/.ssh
mkdir -p $SSH_PATH
chmod 700 $SSH_PATH
cd /vagrant
cp id_rsa* authorized_keys config $SSH_PATH

# 5. Remove SWAP
sed -ri "s/([0-9a-zA-Z\=\-]+) none            swap/#\1 none            swap/g" /etc/fstab
swapoff -a
