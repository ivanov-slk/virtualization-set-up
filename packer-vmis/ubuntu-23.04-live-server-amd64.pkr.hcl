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
  default = "23.04"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-22.10-live-server-amd64"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:c7cda48494a6d7d9665964388a3fc9c824b3bef0c9ea3818a1be982bc80d346b"
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
  iso_checksum            = var.iso_checksum
  iso_url                 = "https://releases.ubuntu.com/${var.distribution_name}/${var.virtual_machine_image}.iso"
  shutdown_command        = "sudo -S shutdown -P now"
  ssh_agent_auth          = true
  ssh_handshake_attempts  = "200"
  ssh_private_key_file    = var.private_key_path
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-${var.virtual_machine_image}"
  hard_drive_interface    = "sata"
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