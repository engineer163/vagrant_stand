Vagrant.configure("2") do |config|

#Ubuntu 18.04 master node with PupperServer
  (1..1).each do |i|
    config.vm.define "master-#{i}" do |master|
      master.vm.box = "ubuntu/bionic64"
      master.vm.hostname = "master-#{i}.stand.com"
      master.vm.network "private_network", ip: "192.168.20.10#{i}"
      master.vm.provision "shell", path: "master-#{i}.sh"
      config.vm.provider "virtualbox" do |v|
       v.memory = 4096
       v.cpus = 2
      end
    end
  end

#Ubuntu 18.04 master node 
  (2..3).each do |i|
    config.vm.define "master-#{i}" do |master|
      master.vm.box = "ubuntu/bionic64"
      master.vm.hostname = "master-#{i}.stand.com"
      master.vm.network "private_network", ip: "192.168.20.10#{i}"
      master.vm.provision "shell", path: "master-#{i}.sh"
    end
  end

#Ubuntu 18.04 nodes
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "ubuntu/bionic64"
      node.vm.hostname = "node-#{i}.stand.com"
      node.vm.network "private_network", ip: "192.168.20.20#{i}"
      node.vm.provision "shell", path: "node-#{i}.sh"
    end
  end

#Common script
  config.vm.provision "shell", path: "bootstrap.sh"
end

