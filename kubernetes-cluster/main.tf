terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
    }
  }
}

resource "vagrant_vm" "kubernetes-cluster-master" {
  count = var.master_count
  vagrantfile_dir = "./kubernetes-cluster"
  env = {
    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    ip_full = "${var.ip_base}.${count.index + 10}",
    cluster_name = var.cluster_name,
    node_name = "master",
    node_count = var.master_count,
    node_cpus = var.master_cpus,
    node_memory = var.master_memory,
  }
  get_ports = true
}

resource "vagrant_vm" "kubernetes-cluster-worker" {
  count = var.worker_count
  vagrantfile_dir = "./kubernetes-cluster"
  env = {
    private_key_path = var.private_key_path,
    virtual_machine_image = var.virtual_machine_image,
    ip_full = "${var.ip_base}.${count.index + 10 + var.master_count}",
    cluster_name = var.cluster_name,
    node_name = "worker",
    node_count = var.worker_count,
    node_cpus = var.worker_cpus,
    node_memory = var.worker_memory
  }
  get_ports = true
}