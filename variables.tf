variable "virtual_machine_image" {
    type = string
    default = "ubuntu-20.04.3-live-server-amd64"
}

variable "private_key_path" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}

variable "ip_base" {
  type    = string
  default = "192.168.50"
}

variable "cluster_name" {
  type    = string
  default = "kubernetes-cluster"
}

variable "master_count" {
  type    = number
  default = 2
}

variable "master_cpus" {
  type    = number
  default = 4
}

variable "master_memory" {
  type    = number
  default = 8192
}

variable "worker_count" {
  type    = number
  default = 3
}

variable "worker_cpus" {
  type    = number
  default = 2
}

variable "worker_memory" {
  type    = number
  default = 4096
}