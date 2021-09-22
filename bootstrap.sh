#!/bin/bash

#Updating the system and installing packages
/usr/bin/apt-get update && /usr/bin/apt-get dist-upgrade --yes
/usr/bin/apt-get install python3-pip python3-venv tree net-tools ntp zip --yes
/usr/bin/apt-get autoremove  --yes && /usr/bin/apt-get autoclean --yes

#Installation and basic configuration of the Consul
export CONSUL_VERSION="1.10.2"
export CONSUL_URL="https://releases.hashicorp.com/consul"
wget ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
sudo mv consul /usr/bin/consul
rm consul_${CONSUL_VERSION}_linux_amd64.zip
sudo chown root:root /usr/bin/consul

# Create a unique, non-privileged system user to run Consul and create its data directory
sudo mkdir -p /etc/consul.d
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir -p /opt/consul
sudo chown --recursive consul:consul /opt/consul

#Setting timezone, date and ntp
/usr/bin/timedatectl set-timezone Europe/Samara
/usr/bin/timedatectl set-ntp true
