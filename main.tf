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
  virtual_machine_image_master = var.virtual_machine_image_master
  private_key_path_master = var.private_key_path_master
  virtual_machine_image_worker = var.virtual_machine_image_worker
  private_key_path_worker = var.private_key_path_worker

  
}

module "vbox-cluster" {  
  source = "./vbox-cluster"
  virtual_machine_image_master = var.virtual_machine_image_master
  private_key_path_master = var.private_key_path_master
  virtual_machine_image_worker = var.virtual_machine_image_worker
  private_key_path_worker = var.private_key_path_worker

}


