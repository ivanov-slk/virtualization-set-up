resource "null_resource" "kubernetes-setup" {
  
  count = 5

  triggers = {
    always_run = "${timestamp()}"
  }

connection {
    type = "ssh"
    user = "vagrant"
    private_key = file("${var.private_key_path}")
    host = "127.0.0.1"
    port = var.virtual_machine_ports[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Machine started.'"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u vagrant 
               -i '127.0.0.1:${var.virtual_machine_ports[count.index]},' 
               --private-key ${var.private_key_path} 
                ${var.virtual_machine_ports[count.index] == 2222 ? 
                    "./kubernetes-cluster/ansible-playbooks/master-playbook.yml" : "./kubernetes-cluster/ansible-playbooks/node-playbook.yml"}
                -e k8s_node_public_ip=192.168.50.${count.index + 10}"
  }
}