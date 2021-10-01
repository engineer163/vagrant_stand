# -*- mode: ruby -*-
# vi: set ft=ruby :
private_net = "192.168.20."
scripts_path = "scripts/"
cpus_node = 1
memory_ram_master = 1024
memory_ram_node = 512
common_install_and_configure_script = scripts_path+"bootstrap.sh"
consul_install_and_configure_script = scripts_path+"consul/consul_install_and_configure.sh"
puppet_install_and_configure_script = scripts_path+"puppet/puppet_install_and_configure.sh"
prometheus_install_and_configure_script = scripts_path+"prometheus/prometheus_install_and_configure.sh"
node_exporter_install_and_configure_script = scripts_path+"prometheus/node_exporter_install_and_configure.sh"
grafana_install_script = scripts_path+"grafana/grafana_install.sh"
master_name = "master-"
slave_name = "slave-"
vag_cluster = [
  { :hostname => master_name+"1", :ip => private_net+"101", :cpus => cpus_node, :mem => memory_ram_master},
  { :hostname => master_name+"2", :ip => private_net+"102", :cpus => cpus_node, :mem => memory_ram_master},
  { :hostname => master_name+"3", :ip => private_net+"103", :cpus => cpus_node, :mem => memory_ram_master},
  { :hostname => slave_name+"1", :ip => private_net+"201", :cpus => cpus_node, :mem => memory_ram_node},
  { :hostname => slave_name+"2", :ip => private_net+"202", :cpus => cpus_node, :mem => memory_ram_node},
]
Vagrant.configure("2") do |config|

# Creating cluster with ubuntu/focal64 using a loop
  vag_cluster.each do |srv|
    config.vm.define srv[:hostname] do |hostcfg|
      hostcfg.vm.box = "ubuntu/focal64"
      hostcfg.vm.box_version = "20210927.0.0"
      hostcfg.vm.hostname = srv[:hostname]
      hostcfg.vm.network :private_network, ip: srv[:ip]
      hostcfg.vm.provider "virtualbox" do |vm|
        vm.name = srv[:hostname]
        vm.memory = srv[:mem]
        vm.cpus = srv[:cpus]
      end
      # Running scripts
      hostcfg.vm.provision "shell", path: common_install_and_configure_script
      hostcfg.vm.provision "shell", path: consul_install_and_configure_script
      hostcfg.vm.provision "shell", path: puppet_install_and_configure_script
      hostcfg.vm.provision "shell", path: prometheus_install_and_configure_script
      hostcfg.vm.provision "shell", path: node_exporter_install_and_configure_script
      hostcfg.vm.provision "shell", path: grafana_install_script
    end
  end
end

