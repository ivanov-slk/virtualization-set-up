terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "virtual-machine-instance" {
  count = 5
  vagrantfile_dir = "./virtual-machine-instance"
  env = {

    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    virtual_machine_index = count.index,
    virtual_machine_hostname = count.index < 2 ? "master" : "worker",
    ip_base = var.ip_base
  }
  get_ports = true
}