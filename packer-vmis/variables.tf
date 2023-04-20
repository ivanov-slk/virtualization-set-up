variable "distribution_name" {
  type     = string
  nullable = false
}

variable "virtual_machine_image" {
  type     = string
  nullable = false
}

variable "virtual_machine_image_sha" {
  type     = string
  nullable = false
}

variable "private_key_path" {
  type     = string
  nullable = false
}
