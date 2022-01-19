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
      "echo Hello, World!"
    ]
  }
}