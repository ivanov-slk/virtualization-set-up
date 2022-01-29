terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "kubernetes-cluster" {
  vagrantfile_dir = "./kubernetes-cluster"
  env = {

    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    ip_base = var.ip_base
  }
  get_ports = true
}