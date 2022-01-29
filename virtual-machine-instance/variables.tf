variable "virtual_machine_image" {
    type = string
    nullable = false 
}

variable "private_key_path" {
  type    = string
  nullable = false 
}

variable "ip_base" {
  type    = string
  nullable = false 
}
