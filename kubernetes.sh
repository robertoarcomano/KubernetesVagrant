#!/bin/bash
# 0. Destroy existence vagrant VMs
source params.sh
echo $CLASS_C".2"" master" > hosts
for i in $(seq 1 10); do
  let j=i+2
  echo $CLASS_C".$j worker$i" >> hosts
done
vagrant destroy -f

# 1. Start Vagrant VMs
vagrant up --provider=libvirt

# 2. Launch tests
#vagrant ssh tighost -c "sudo /vagrant/testTIG.sh"
