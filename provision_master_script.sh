#!/bin/bash

# 0. Load Params
# source /vagrant/params.sh

# 1. Create cluster
kubeadm init --pod-network-cidr=10.244.10.0/16|tail -2 > join.sh
chmod +x join.sh
#--apiserver-advertise-address=10.0.15.10

# 2. Copy configuration
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 3. Make workers join
for i in $(seq 1 2); do
  scp join.sh worker$i:/tmp
  ssh worker$i /tmp/join.sh
done

# 4. Deploy a Pod Network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 5. Create a deployment
cd /vagrant
kubectl create -f nginx-deployment.yaml

# 6. Create a service
kubectl create -f nginx-service.yaml

# 7. Install Dashboard
kubectl apply -f /vagrant/dashboard.yaml
kubectl apply -f /vagrant/dashboard_service_account.yaml
kubectl apply -f /vagrant/dashboard_cluster_role_binding.yaml

# 8. Launch Dashboard
nohup kubectl proxy 2>&1 > logfile.txt &
