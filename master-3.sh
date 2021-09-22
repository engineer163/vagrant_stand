#!/bin/bash
ipaddr="192.168.20.103"
sudo touch /etc/consul.d/server.hcl
sudo touch /etc/consul.d/consul.hcl
sudo touch /etc/systemd/system/consul.service
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/server.hcl
sudo chmod 640 /etc/consul.d/consul.hcl

#consul.hcl
sudo tee -a /etc/consul.d/consul.hcl > /dev/null <<EOT
datacenter = "stand"
data_dir = "/opt/consul"
rejoin_after_leave = true
EOT

#server.hcl
sudo tee -a /etc/consul.d/server.hcl > /dev/null <<EOT
server = true
bootstrap_expect = 3
client_addr = "0.0.0.0"
ui = true
bind_addr = "$ipaddr"
advertise_addr = "$ipaddr"
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
