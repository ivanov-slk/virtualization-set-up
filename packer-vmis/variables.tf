variable "virtual_machine_image_master" {
    type = string
    nullable = false 
}

variable "private_key_path_master" {
  type    = string
  nullable = false 
}

variable "virtual_machine_image_worker" {
    type = string
    nullable = false 
}

variable "private_key_path_worker" {
  type    = string
  nullable = false 
}