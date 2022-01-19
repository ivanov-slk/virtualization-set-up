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

module "virtual-machine-instance" {  
  source = "./virtual-machine-instance"
  virtual_machine_image = var.virtual_machine_image
  private_key_path = var.private_key_path
}

module "kubernetes-cluster" {  
  source = "./kubernetes-cluster"
  private_key_path = var.private_key_path
  virtual_machine_configuration = module.virtual-machine-instance.virtual_machine_configuration

  depends_on = [module.virtual-machine-instance]
}


