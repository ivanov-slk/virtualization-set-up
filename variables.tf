variable "distribution_name" {
  type    = string
  default = "24.04"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-24.04-live-server-amd64"
}

variable "virtual_machine_image_sha" {
  type    = string
  default = "8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
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
