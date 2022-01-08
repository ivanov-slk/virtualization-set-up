terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }
  }
}

resource "vagrant_vm" "ubuntu-server-master" {
  vagrantfile_dir = "."
  env = {
    virtual_machine_image_master = var.virtual_machine_image_master,
    private_key_path_master = var.private_key_path_master
  }
  get_ports = true
}