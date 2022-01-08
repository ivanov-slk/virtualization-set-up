variable "virtual_machine_image_master" {
    type = string
    default = "ubuntu-20.04.3-live-server-amd64-master"
}

variable "private_key_path_master" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}