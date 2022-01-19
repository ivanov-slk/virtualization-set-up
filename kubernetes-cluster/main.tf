resource "null_resource" "kubernetes-setup" {
  

  for_each = var.virtual_machine_configuration

  triggers = {
    always_run = "${timestamp()}"
  }

connection {
    type = "ssh"
    user = "vagrant"
    private_key = file("${var.private_key_path}")
    host = "127.0.0.1"
    port = each.value
  }

  provisioner "remote-exec" {
    script = each.value == 2222 ? "./kubernetes-cluster/master-set-up.sh" : "./kubernetes-cluster/worker-set-up.sh"
  }
}