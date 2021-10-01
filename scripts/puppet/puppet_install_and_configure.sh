#!/bin/bash
# Installing pupppet server or agent
puppet_package="puppet7-release-focal"
file_path=/vagrant/scripts/puppet
wget https://apt.puppet.com/${puppet_package}.deb -q || { echo "Error downloading Puppet!" && exit 2; }
sudo dpkg -i ${puppet_package}.deb > /dev/null
sudo rm ${puppet_package}.deb
sudo apt-get update > /dev/null

case $HOSTNAME in
    (master-1) sudo apt-get install puppetserver --yes > /dev/null ;;
    (master-*) sudo apt-get install puppet-agent --yes > /dev/null ;;
    (slave-*) sudo apt-get install puppet-agent --yes > /dev/null ;;
    (*) echo "This is no puppet server!" && exit 2 ;;
esac

# Configuring /etc/hosts
sudo printf "192.168.20.101  puppet\n192.168.20.101  master-1\n192.168.20.102  master-2\n192.168.20.103 \
 master-3\n192.168.20.201  slave-1\n192.168.20.202 slave-2" >> /etc/hosts

# Configuring puppet.conf
case $HOSTNAME in
    (master-1) sudo sed -e 's/NODE_NAME/master-1/g' $file_path/puppet.conf >> /etc/puppetlabs/puppet/puppet.conf ;;
    (master-2) sudo sed -e 's/NODE_NAME/master-2/g' $file_path/puppet.conf >> /etc/puppetlabs/puppet/puppet.conf ;;
    (master-3) sudo sed -e 's/NODE_NAME/master-3/g' $file_path/puppet.conf >> /etc/puppetlabs/puppet/puppet.conf ;;
    (slave-1) sudo sed -e 's/NODE_NAME/slave-1/g' $file_path/puppet.conf >> /etc/puppetlabs/puppet/puppet.conf ;;
    (slave-2) sudo sed -e 's/NODE_NAME/slave-2/g' $file_path/puppet.conf >> /etc/puppetlabs/puppet/puppet.conf ;;
    (*) echo "This is no puppet server!" && exit 2 ;;
esac

if [ $HOSTNAME == "master-1" ]; then
    # Modify memory allocation for puppetserver for our small stand
    sudo sed -e 's/2g/512m/g' /etc/default/puppetserver >> /etc/default/puppetserver
    # Autosign certificate
    echo '*' | sudo tee -a /etc/puppetlabs/puppet/autosign.conf > /dev/null
    # Create CA puppetserver
    sudo /opt/puppetlabs/server/bin/puppetserver ca setup > /dev/null
    # Add puppet manifest
    sudo cp $file_path/puppet_manifest.pp /etc/puppetlabs/code/environments/production/manifests/install_tree.pp
    # Enable and run service puppetserver
    sudo systemctl enable puppetserver > /dev/null
    sudo systemctl start puppetserver > /dev/null
    sleep 10
else
    # Enable and run service puppet-agent
    sudo systemctl enable puppet > /dev/null
    sudo systemctl start puppet > /dev/null
fi
