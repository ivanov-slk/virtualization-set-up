terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "ubuntu-server-instance" {
  count = 5
  vagrantfile_dir = "./virtual-machine-instance"
  env = {

    virtual_machine_image = var.virtual_machine_image,
    private_key_path = var.private_key_path,
    virtual_machine_index = count.index
  }
  get_ports = true
}