#!/usr/bin/bash

# TODO: find out how to avoid hardcoding packer variables here, or avoid using bash altogether...

# remove unneeded files
rm -r /home/slav/VirtualBox\ VMs/packer-ubuntu-20.04.3-live-server-amd64/
rm -r .vagrant || true
rm -r *.box || true

# packer
PACKER_LOG=1 packer build ubuntu-server-2004.pkr.hcl 

# vagrant
vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f
vagrant destroy ubuntu-20.04.3-live-server-amd64-master -f
vboxmanage unregistervm --delete ubuntu-20.04.3-live-server-amd64-master
vagrant up && vagrant halt