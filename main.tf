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

module "kubernetes-cluster" {  
  source = "./kubernetes-cluster"
  virtual_machine_image = var.virtual_machine_image
  private_key_path = var.private_key_path
  ip_base = var.ip_base

  #depends_on = [module.packer-vmis]
}


