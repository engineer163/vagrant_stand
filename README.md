# Vagrant stand

Don't forget to create git branch for every step and merge branch into master when step is finished.

Five machines.
Three masters:
+ 1024 RAM
+ 1 CPU

Two nodes:
+ 512 RAM
+ 1 CPU

Default Box Version - ubuntu\focal64 or bento/ubuntu-20.04.

Steps:
+ Installing and configuring Consul servers on masters and Consul agents on nodes
+ Create script to automatically install and configure Consul cluster on `vagrant up`
+ Install Puppet servers on first master and Puppet anget on other nodes
+ Create scripts to automatically install Puppet server and Puppet agents

TODO's:
+ Use Puppet to manage Consul cluster
+ Use Puppet to install node-exporters on all nodes
+ Use Puppet to install Prometheus on all masters nodes
+ Use Puppet to configure Prometheus instances monitor each other and scrape metrics from node-exporters
