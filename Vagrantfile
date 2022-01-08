# -*- mode: ruby -*-
# vi: set ft=ruby :

virtual_machine_image_master = ENV["virtual_machine_image_master"] # || "ubuntu-20.04.3-live-server-amd64"
private_key_path_master = ENV["private_key_path_master"] # || "/home/slav/.ssh/virtual_id_ed25519"

Vagrant.configure("2") do |config|
    config.vm.box = virtual_machine_image_master
    config.vm.box_url = "file://./#{virtual_machine_image_master}.box"
  
    config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.name = virtual_machine_image_master

    config.ssh.connect_timeout = 20
    config.ssh.username = "vagrant"
    config.ssh.insert_key = false
    config.ssh.private_key_path = private_key_path_master
    end
  
  end