variable "virtual_machine_image" {
    type = string
    default = "ubuntu-20.04.3-live-server-amd64"
}

variable "private_key_path" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}