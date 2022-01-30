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

variable "cluster_name" {
  type    = string
  nullable = false 
}

variable "master_count" {
  type    = number
  nullable = false 
}

variable "master_cpus" {
  type    = number
  nullable = false 
}

variable "master_memory" {
  type    = number
  nullable = false 
}

variable "node_count" {
  type    = number
  nullable = false 
}

variable "node_cpus" {
  type    = number
  nullable = false 
}

variable "node_memory" {
  type    = number
  nullable = false 
}
