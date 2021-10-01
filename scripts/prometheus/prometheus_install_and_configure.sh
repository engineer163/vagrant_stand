#!/bin/bash
# Installing prometheus on master nodes
file_path=/vagrant/scripts/prometheus
prometheus_version="2.30.0"
if echo $HOSTNAME | grep master*; then
    wget https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz -q \
    || { echo "Error downloading Prometheus!" && exit 2; }
    tar -xf prometheus-${prometheus_version}.linux-amd64.tar.gz
    rm prometheus-${prometheus_version}.linux-amd64.tar.gz
    cd prometheus-${prometheus_version}.linux-amd64
    sudo mkdir -p /etc/prometheus/consoles /etc/prometheus/console_libraries /var/lib/prometheus
    sudo mv prometheus promtool /usr/bin
    sudo mv consoles/* /etc/prometheus/consoles/
    sudo mv console_libraries/* /etc/prometheus/console_libraries/
    sudo mv prometheus.yml /etc/prometheus/
    sudo useradd -M -r -s /bin/false prometheus
    sudo cp $file_path/prometheus.service /etc/systemd/system/prometheus.service
    sudo cp -f $file_path/prometheus.yml /etc/prometheus/prometheus.yml
    sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
    sudo systemctl daemon-reload
    sudo systemctl enable prometheus
    sudo systemctl start prometheus
    sudo systemctl status prometheus
fi
