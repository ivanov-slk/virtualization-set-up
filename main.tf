terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
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
  cluster_name = var.cluster_name
  master_count = var.master_count
  master_cpus = var.master_cpus
  master_memory = var.master_memory
  worker_count = var.worker_count
  worker_cpus = var.worker_cpus
  worker_memory = var.worker_memory

  #depends_on = [module.packer-vmis]
}

module "kubernetes-tools" {
  source = "./kubernetes-tools"
}

