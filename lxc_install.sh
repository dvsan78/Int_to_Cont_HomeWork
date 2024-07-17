#!/bin/bash
echo “Updating system and installing dependences”
apt-get update 
apt-get upgrade -y  
apt-get install lxc lxc-astra
echo “Create conteiner name myapp”
lxc-create -t astralinux-se -n myapp
lxc-start myapp
lxc-attach myapp
apt-get update
apt-install nginx php-fpm
