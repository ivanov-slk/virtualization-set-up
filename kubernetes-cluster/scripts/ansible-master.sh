#! /usr/bin/bash

ansible-playbook  -u vagrant -i '127.0.0.1:${ var.virtual_machine_ports[count.index] },' --private-key ${var.private_key_path} ${var.virtual_machine_ports[count.index] == 2222 ? "./kubernetes-cluster/ansible-playbooks/master-playbook.yml" : "./kubernetes-cluster/ansible-playbooks/node-playbook.yml"} -e k8s_node_public_ip='192.168.50.${count.index + 11}' -e k8s_cluster_name='k8s-cluster'