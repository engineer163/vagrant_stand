#!/bin/bash
# Installing grafana on master-1 nodes
if echo $HOSTNAME | grep master-1; then
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
    sudo apt-get update && sudo apt-get install grafana \
    && echo "Grafana installed." || { echo "Grafana not installed! Error!" && exit 2; }
    sudo systemctl daemon-reload
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server.service
    sudo systemctl status grafana-server
fi
exit