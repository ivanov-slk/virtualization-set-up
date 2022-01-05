# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu-20.04-test"
    config.vm.box_url = "file://./ubuntu-20.04-test.box"
  
    config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.name = "ubuntu-20.04-test"

    config.ssh.connect_timeout = 20
    config.ssh.username = "vagrant"
    config.ssh.insert_key = false
    config.ssh.private_key_path = ["/home/slav/.ssh/virtual_id_ed25519"]
    end
  
  end