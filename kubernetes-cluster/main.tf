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
    ip_base = var.ip_base,
    cluster_name = var.cluster_name,
    master_count = var.master_count,
    master_cpus = var.master_cpus,
    master_memory = var.master_memory,
    node_count = var.node_count,
    node_cpus = var.node_cpus,
    node_memory = var.node_memory
  }
  get_ports = true
}