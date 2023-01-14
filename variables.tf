variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-22.10-live-server-amd64"
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
  default = 4
}

variable "master_memory" {
  type    = number
  default = 2048
}

variable "worker_count" {
  type    = number
  default = 4
}

variable "worker_cpus" {
  type    = number
  default = 4
}

variable "worker_memory" {
  type    = number
  default = 8192
}
