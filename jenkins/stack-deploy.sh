#!/bin/bash

set -e

source ~/.openrc

ip=$(heat output-show rpc-jenkins-${BUILD_NUMBER} controller1_ip | sed -e 's/"//g')
checkout="/root/ansible-lxc-rpc/rpc_deployment"
ssh_key=~/.ssh/jenkins

# Temporary commands to test new neutron library
ssh -l root -i $ssh_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ip "cd $checkout && curl -o library/neutron https://gist.githubusercontent.com/mattt416/de164b5737c475b2b9ac/raw/efc181f59c6173cdbad8ef68fee2f6efa9f13173/gistfile1.txt"
scp -i $ssh_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null jenkins/tempest_resources.yml root@${ip}:${checkout}/roles/tempest_resources/tasks/main.yml

ssh -l root -i $ssh_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ip "cd $checkout && bash run_ansible.sh"