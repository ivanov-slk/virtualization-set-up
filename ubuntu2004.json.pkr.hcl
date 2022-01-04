
source "virtualbox-iso" "autogenerated_1" {
  boot_command            = ["<enter><wait2><enter><wait><f6><esc><wait>", "autoinstall<wait2> ds=nocloud;", "<wait><enter>"]
  boot_wait               = "2s"
  cd_files                = ["./http/user-data", "./http/meta-data"]
  cd_label                = "cidata"
  disk_size               = 8192
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  headless                = false
  http_directory          = "http"
  iso_checksum            = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  iso_urls                = ["https://releases.ubuntu.com/focal/ubuntu-20.04.3-live-server-amd64.iso"]
  shutdown_command        = "echo 'ubuntu'|sudo -S shutdown -P now"
  ssh_agent_auth          = true
  ssh_handshake_attempts  = "200"
  ssh_private_key_file    = "/home/slav/.ssh/virtual_id_ed25519"
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "1024"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "packer-ubuntu-20.04-amd64"
}

build {
  sources = ["source.virtualbox-iso.autogenerated_1"]

  provisioner "shell" {
    scripts = ["scripts/init.sh", "scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    compression_level = "8"
    output            = "ubuntu-20.04-<no value>.box"
  }
}
