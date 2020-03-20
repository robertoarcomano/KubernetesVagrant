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
cat ~/.ssh/id_rsa.pub >> authorized_keys

# 2. Start Vagrant VMs
vagrant up --provider=libvirt

# 3. Activate Dashboard and create tunnel ssh 8001:8001
#ssh-keygen -f "/home/berto/.ssh/known_hosts" -R "master"
# ssh -o StrictHostKeyChecking=no -L 8001:localhost:8001 root@master "
#   kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')|grep token;
#   echo 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/';
#   /bin/bash"

# 4. Launch tests
vagrant ssh master -c "sudo /vagrant/testKubernetes.sh"
