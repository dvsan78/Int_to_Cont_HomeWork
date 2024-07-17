#!/bin/bash
echo “Updating system and installing dependences”
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get install lxc lxc-astra
echo “Create conteiner name $1”
lxc-create -t astralinux-se  -n $1