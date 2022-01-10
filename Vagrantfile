# -*- mode: ruby -*-
# vi: set ft=ruby :

virtual_machine_image_master = ENV["virtual_machine_image_master"] || "ubuntu-20.04.3-live-server-amd64"
private_key_path_master = ENV["private_key_path_master"] || "/home/slav/.ssh/virtual_id_ed25519"
virtual_machine_image_worker = ENV["virtual_machine_image_worker"] || "ubuntu-20.04.3-live-server-amd64"
private_key_path_worker = ENV["private_key_path_worker"] || "/home/slav/.ssh/virtual_id_ed25519"

Vagrant.configure("2") do |config|
  config.vm.define "#{virtual_machine_image_master}-master" do |master|
    master.vm.box = virtual_machine_image_master
    master.vm.box_url = "file://./#{virtual_machine_image_master}.box"
  
    master.vm.provider "virtualbox" do |master_vm|
      master_vm.gui = false
      master_vm.name = "#{virtual_machine_image_master}-master"
      master_vm.cpus = 4
      master_vm.memory = 8192
  
      master.ssh.connect_timeout = 20
      master.ssh.username = "vagrant"
      master.ssh.insert_key = false
      master.ssh.private_key_path = private_key_path_master
    end
  end

  (1..4).each do |i|
    config.vm.define "#{virtual_machine_image_worker}-worker-#{i}" do |worker|
      worker.vm.box = virtual_machine_image_worker
      worker.vm.box_url = "file://./#{virtual_machine_image_worker}.box"
      worker.vm.provider "virtualbox" do |worker_config|
        worker_config.name = "#{virtual_machine_image_worker}-worker-#{i}"
        worker_config.cpus = 2
        worker_config.memory = 4096

      worker.ssh.connect_timeout = 20
      worker.ssh.username = "vagrant"
      worker.ssh.insert_key = false
      worker.ssh.private_key_path = private_key_path_worker
    end
  end
end
end