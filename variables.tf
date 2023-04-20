variable "distribution_name" {
  type    = string
  default = "23.04"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-23.04-live-server-amd64"
}

variable "virtual_machine_image_sha" {
  type    = string
  default = "c7cda48494a6d7d9665964388a3fc9c824b3bef0c9ea3818a1be982bc80d346b"
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
