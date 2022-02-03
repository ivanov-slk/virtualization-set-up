terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "kubernetes-cluster-master" {
  vagrantfile_dir = "./kubernetes-cluster"
  env = {
    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    ip_base = var.ip_base,
    ip_offset = 10,
    cluster_name = var.cluster_name,
    node_name = "master",
    node_count = var.master_count,
    node_cpus = var.master_cpus,
    node_memory = var.master_memory,
  }
  get_ports = true
}

resource "vagrant_vm" "kubernetes-cluster-worker" {
  vagrantfile_dir = "./kubernetes-cluster"
  env = {
    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    ip_base = var.ip_base,
    ip_offset = var.master_count + 10,
    cluster_name = var.cluster_name,
    node_name = "worker",
    node_count = var.worker_count,
    node_cpus = var.worker_cpus,
    node_memory = var.worker_memory
  }
  get_ports = true

  depends_on = [vagrant_vm.kubernetes-cluster-master]
}