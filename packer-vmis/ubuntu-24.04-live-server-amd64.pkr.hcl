packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

variable "disk_size" {
    type    = number
    default = 65536
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "distribution_name" {
  type    = string
  default = "24.04"
}

variable "virtual_machine_image" {
  type    = string
  default = "ubuntu-24.04-live-server-amd64"
}

variable "virtual_machine_image_sha" {
  type    = string
  default = "sha256:8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
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
  # Set memory to almost anything larger than the default; see:
  # https://www.reddit.com/r/Ubuntu/comments/hbm7ib/attempting_to_install_ubuntu_2004_in_vmware/
  cpus                    = var.cpus
  memory                  = var.memory
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = false
  iso_checksum            = var.virtual_machine_image_sha
  iso_url                 = "https://releases.ubuntu.com/${var.distribution_name}/${var.virtual_machine_image}.iso"
  shutdown_command        = "sudo -S shutdown -P now"
  ssh_agent_auth          = true
  ssh_handshake_attempts  = "2000"
  ssh_private_key_file    = var.private_key_path
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "20000s"
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
