#!/bin/bash
CONSUL_VERSION="1.10.2"
file_path=/vagrant/scripts/consul
ip_address=$(hostname -I | awk '{print $2}')
# Installation and basic configuration system for the Consul
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -q \
|| { echo "Error downloading Consul!" && exit 2; }
unzip consul_${CONSUL_VERSION}_linux_amd64.zip > /dev/null
sudo mv consul /usr/bin/consul
rm consul_${CONSUL_VERSION}_linux_amd64.zip
sudo chown root:root /usr/bin/consul

# Create a unique, non-privileged system user to run Consul and create its data directory
sudo mkdir -p /etc/consul.d
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir -p /opt/consul
sudo chown --recursive consul:consul /opt/consul && echo "Consul was install."

# Copy systemd unit for consul
sudo cp $file_path/consul.service /etc/systemd/system/consul.service

# Configuring consul.hcl
case $HOSTNAME in
    (master-*) sed -e "s/ipaddr/$ip_address/g" $file_path/consul_master.hcl | sudo tee /etc/consul.d/consul.hcl > /dev/null;;
    (slave-*) sed -e "s/ipaddr/$ip_address/g" $file_path/consul_node.hcl | sudo tee /etc/consul.d/consul.hcl > /dev/null ;;
    (*) echo "This is no Consul server!" && exit 2 ;;
esac
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

# Enable and Start Consul
sudo systemctl enable consul > /dev/null
sudo systemctl start consul && echo "Consul running."
exit
