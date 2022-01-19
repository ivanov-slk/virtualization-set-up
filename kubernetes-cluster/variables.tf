variable "private_key_path" {
  type     = string
  nullable = false
}

variable "virtual_machine_ports" {
  type = list
}

variable "virtual_machine_names" {
  type = list
}