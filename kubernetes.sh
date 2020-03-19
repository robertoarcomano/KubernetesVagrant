#!/bin/bash
# 0. Destroy existence vagrant VMs
source params.sh
echo $CLASS_C".2"" master" > hosts
for i in $(seq 1 10); do
  let j=i+2
  echo $CLASS_C".$j worker$i" >> hosts
done
vagrant destroy -f

# 1. Create SSH Keys
rm -f id_rsa* authorized_keys
ssh-keygen -t rsa -f id_rsa -P ""
cp id_rsa.pub authorized_keys

# 2. Start Vagrant VMs
vagrant up --provider=libvirt

# 3. Launch tests
#vagrant ssh tighost -c "sudo /vagrant/testTIG.sh"
