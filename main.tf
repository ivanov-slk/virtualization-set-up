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


