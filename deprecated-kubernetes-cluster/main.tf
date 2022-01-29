locals {
  nodes_list = range(1, 5)
}

resource "null_resource" "kubernetes-setup-master" {

  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    type = "ssh"
    user = "vagrant"
    private_key = file("${var.private_key_path}")
    host = "127.0.0.1"
    port = var.virtual_machine_ports[0]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Machine started.'"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u vagrant -i '127.0.0.1:${var.virtual_machine_ports[0]},' --private-key ${var.private_key_path} ./kubernetes-cluster/ansible-playbooks/master-playbook.yml -e k8s_node_public_ip='192.168.50.10' -e k8s_master_apiserver_advertise_address='192.168.50.10}' -e k8s_cluster_name='k8s-cluster' -e k8s_master_node_name='master-node-0'"
  }
}

resource "null_resource" "kubernetes-setup-node" {
  
  for_each = toset(var.nodes_list)

  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    type = "ssh"
    user = "vagrant"
    private_key = file("${var.private_key_path}")
    host = "127.0.0.1"
    port = var.virtual_machine_ports[each.key]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Machine started.'"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u vagrant -i '127.0.0.1:${var.virtual_machine_ports[each.key]},' --private-key ${var.private_key_path} ./kubernetes-cluster/ansible-playbooks/node-playbook.yml -e k8s_node_public_ip='192.168.50.${each.key + 10}' -e k8s_cluster_name='k8s-cluster'"
  }
  
  depends_on = ["null_resource.kubernetes-setup-master"]
}
