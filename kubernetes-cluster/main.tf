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
    master_count = var.master_count,
    master_cpus = var.master_cpus,
    master_memory = var.master_memory,
    worker_count = var.worker_count,
    worker_cpus = var.worker_cpus,
    worker_memory = var.worker_memory
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
    master_count = var.master_count,
    master_cpus = var.master_cpus,
    master_memory = var.master_memory,
    worker_count = var.worker_count,
    worker_cpus = var.worker_cpus,
    worker_memory = var.worker_memory
  }
  get_ports = true
}