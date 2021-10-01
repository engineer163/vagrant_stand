#!/bin/bash
node_exporter_version="1.2.2"
file_path=/vagrant/scripts/prometheus
wget https://github.com/prometheus/node_exporter/releases/download/v$node_exporter_version/node_exporter-$node_exporter_version.linux-amd64.tar.gz -q \
|| { echo "Error downloading Node exporter!" && exit 2; }
tar -xf node_exporter-$node_exporter_version.linux-amd64.tar.gz
rm node_exporter-$node_exporter_version.linux-amd64.tar.gz
sudo mv node_exporter-$node_exporter_version.linux-amd64/node_exporter /usr/bin/
sudo rm -rf node_exporter-$node_exporter_version.linux-amd64/
sudo useradd -M -r -s /bin/false node_exporter
sudo cp $file_path/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter.service
sudo systemctl enable node_exporter.service
