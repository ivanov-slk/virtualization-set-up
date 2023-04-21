variable "distribution_name" {
  type    = string
  default = "22.10"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-22.10-live-server-amd64"
}

variable "virtual_machine_image_sha" {
  type    = string
  default = "874452797430a94ca240c95d8503035aa145bd03ef7d84f9b23b78f3c5099aed"
}

variable "private_key_path" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}

variable "ip_base" {
  type    = string
  default = "192.168.56"
}

variable "cluster_name" {
  type    = string
  default = "kubernetes-cluster"
}

variable "master_count" {
  type    = number
  default = 1
}

variable "master_cpus" {
  type    = number
  default = 2
}

variable "master_memory" {
  type    = number
  default = 4096
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "worker_cpus" {
  type    = number
  default = 4
}

variable "worker_memory" {
  type    = number
  default = 8192
}
