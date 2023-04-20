variable "disk_size" {
    type    = number
    default = 32768
}

variable "cpus" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1024
}

variable "distribution_name" {
  type    = string
  default = "focal"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-20.04.3-live-server-amd64"
}

variable "virtual_machine_image_sha" {
  type    = string
  default = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
}

variable "private_key_path" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}

source "virtualbox-iso" "ubuntu-server-vmi" {
  boot_command            = ["<enter><wait2><enter><wait><f6><esc><wait>", "autoinstall<wait2> ds=nocloud;", "<wait><enter>"]
  boot_wait               = "2s"
  cd_files                = ["./cloud-config/user-data", "./cloud-config/meta-data"]
  cd_label                = "cidata"
  disk_size               = var.disk_size
  cpus                    = var.cpus
  memory                  = var.memory
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = false
  iso_checksum            = var.virtual_machine_image_sha
  iso_url                 = "https://releases.ubuntu.com/${var.distribution_name}/${var.virtual_machine_image}.iso"
  shutdown_command        = "sudo -S shutdown -P now"
  ssh_agent_auth          = true
  ssh_handshake_attempts  = "200"
  ssh_private_key_file    = var.private_key_path
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-${var.virtual_machine_image}"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-server-vmi"]

  provisioner "shell" {
    scripts = ["scripts/init.sh"]
  }

  provisioner "shell" {
    scripts = ["scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    compression_level = "8"
    output            = "${var.virtual_machine_image}.box"
  }
}
