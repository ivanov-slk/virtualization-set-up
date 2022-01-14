terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "ubuntu-server-master" {
  vagrantfile_dir = "./vbox-cluster"
  env = {
    virtual_machine_image_master = var.virtual_machine_image_master,
    private_key_path_master = var.private_key_path_master,
    virtual_machine_image_worker = var.virtual_machine_image_worker,
    private_key_path_worker = var.private_key_path_worker
  }
  get_ports = true
}