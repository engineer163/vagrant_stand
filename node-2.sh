#!/bin/bash
ipaddr="192.168.20.202"
sudo touch /etc/consul.d/consul.hcl
sudo touch /etc/systemd/system/consul.service
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

#consul.hcl
sudo tee -a /etc/consul.d/consul.hcl > /dev/null <<EOT
datacenter = "stand"
data_dir = "/opt/consul"
rejoin_after_leave = true
bind_addr = "$ipaddr"
advertise_addr = "$ipaddr"
retry_join = ["192.168.20.101"]
retry_join = ["192.168.20.102"]
retry_join = ["192.168.20.103"]
EOT

# Create unit systemd for Ubuntu 18.04
sudo tee -a /etc/systemd/system/consul.service > /dev/null << EOT
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
Type=simple
User=consul
Group=consul
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

#Enable and Start Consul
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul

#Installing pupppet agent and configuring hosts
wget https://apt.puppet.com/puppet7-release-bionic.deb
sudo dpkg -i puppet7-release-bionic.deb
sudo apt-get update
sudo apt-get install puppet-agent --yes
sudo tee -a /etc/hosts > /dev/null << EOT
192.168.20.101	master-1
192.168.20.101	puppet
$ipaddr	node-2
EOT

#Configuring puppet-agent
sudo tee -a /etc/puppetlabs/puppet/puppet.conf > /dev/null << EOT
[main]
certname = node-2
server = master-1
environment = production
runinterval = 15m
EOT

#Enable and run service puppet-agent
sudo systemctl enable puppet
sudo systemctl start puppet
#sudo /opt/puppetlabs/bin/puppet ssl bootstrap \& > /dev/null
