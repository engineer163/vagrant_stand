#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
# Updating the system and installing packages
/usr/bin/apt-get update > /dev/null && echo "System updated." || { echo "System not updated!" && exit 2; }
/usr/bin/apt-get dist-upgrade --yes > /dev/null && echo "System upgraded." || { echo "System not upgraded!" && exit 2; }
/usr/bin/apt-get install python3-pip python3-venv net-tools zip apt-transport-https software-properties-common wget --yes > /dev/null \
&& echo "Software installed." || { echo "Software not installed!" && exit 2; }
/usr/bin/apt-get autoremove --yes > /dev/null && /usr/bin/apt-get autoclean --yes > /dev/null || exit 2

# Setting timezone, date and ntp
sudo timedatectl set-timezone Europe/Samara
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd.service && echo "Time syncronization complete."
exit
