variable "disk_size_master" {
    type    = number
    default = 8192
}

variable "cpus_master" {
  type    = number
  default = 1
}

variable "memory_master" {
  type    = number
  default = 1024
}

variable "distribution_name_master" {
  type    = string
  default = "focal"
}

variable "os_version_name_master" {
  type    = string
  default = "ubuntu-20.04.3-live-server-amd64"
}

variable "iso_checksum_master" {
  type    = string
  default = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
}

variable "private_key_file_master" {
  type    = string
  default = "/home/slav/.ssh/virtual_id_ed25519"
}

source "virtualbox-iso" "ubuntu-server-master" {
  boot_command            = ["<enter><wait2><enter><wait><f6><esc><wait>", "autoinstall<wait2> ds=nocloud;", "<wait><enter>"]
  boot_wait               = "2s"
  cd_files                = ["./cloud-config/user-data", "./cloud-config/meta-data"]
  cd_label                = "cidata"
  disk_size               = var.disk_size_master
  cpus                    = var.cpus_master
  memory                  = var.memory_master
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = false
  iso_checksum            = var.iso_checksum_master
  iso_url                 = "https://releases.ubuntu.com/${var.distribution_name_master}/${var.os_version_name_master}.iso"
  shutdown_command        = "sudo -S shutdown -P now"
  ssh_agent_auth          = true
  ssh_handshake_attempts  = "200"
  ssh_private_key_file    = var.private_key_file_master
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-${var.os_version_name_master}"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-server-master"]

  provisioner "shell" {
    scripts = ["scripts/init.sh"]
  }

  provisioner "shell" {
    scripts = ["scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    compression_level = "8"
    output            = "${var.os_version_name_master}-master.box"
  }
}
