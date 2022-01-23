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
    #script = var.virtual_machine_ports[count.index] == 2222 ? "./kubernetes-cluster/master-set-up.sh" : "./kubernetes-cluster/worker-set-up.sh"
    scripts = [
      "./kubernetes-cluster/scripts/disable_swap.sh",
      "./kubernetes-cluster/scripts/load_br_netfilter.sh",
      "./kubernetes-cluster/scripts/install_containerd.sh",
      "./kubernetes-cluster/scripts/install_kubepackages.sh"
    ]
  }
}