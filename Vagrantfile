CLASS_C=ENV['CLASS_C']
NUM_WORKERS=ENV['NUM_WORKERS']
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box = "generic/ubuntu1804"
  config.vm.provision "shell" do |s|
      s.path = "provision_common_script.sh"
    end
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 4096
    libvirt.cpus   = 2
  end

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "#{CLASS_C}.2"
    master.vm.provision "shell" do |s|
      s.path = "provision_master_script.sh"
    end
  end

  #TODO: (1..Integer("#{NUM_WORKERS}")).each do |i|
  (1..2).each do |i|
    config.vm.define "worker#{i}" do |node|
      node.vm.hostname = "worker#{i}"
      node.vm.network :private_network, ip: "#{CLASS_C}.#{i+2}"
      node.vm.provision "shell" do |s|
         s.path = "provision_worker_script.sh"
      end
    end
  end
end
