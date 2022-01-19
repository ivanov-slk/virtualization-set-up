terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }
  }
}

module "packer-vmis" {
  source = "./packer-vmis"
  virtual_machine_image = var.virtual_machine_image
  private_key_path = var.private_key_path  
}

module "vbox-cluster" {  
  source = "./vbox-cluster"
  virtual_machine_image = var.virtual_machine_image
  private_key_path = var.private_key_path
}

module "kubernetes-cluster" {  
  source = "./kubernetes-cluster"
  private_key_path = var.private_key_path
  virtual_machine_ports = module.vbox-cluster.virtual_machine_ports
  virtual_machine_names = module.vbox-cluster.virtual_machine_names
}


