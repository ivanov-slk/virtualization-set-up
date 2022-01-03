# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu-20.04-<no value>"
    config.vm.box_url = "file://./ubuntu-20.04-<no value>.box"
  
    config.vm.network "forwarded_port", guest: 80, host: 8080
  
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true
      vb.name = "ubuntu-20.04-server-master"

    config.ssh.insert_key = false
    config.ssh.private_key_path = ["/home/slav/.ssh/virtual_id_ed25519", "~/.vagrant.d/insecure_private_key"]
    config.vm.provision "file", source: "/home/slav/.ssh/virtual_id_ed25519", destination: "~/.ssh/authorized_keys"
    end
  
  end