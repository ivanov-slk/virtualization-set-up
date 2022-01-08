#!/usr/bin/bash

# remove unneeded files
rm -r /home/slav/VirtualBox\ VMs/packer-ubuntu-20.04-amd64/
rm -r .vagrant || true
rm -r *.box || true

# packer
PACKER_LOG=1 packer build ubuntu-server-2004.pkr.hcl

# vagrant
vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f
vagrant destroy ubuntu-20.04-test -f
vboxmanage unregistervm --delete ubuntu-20.04-test
vagrant up && vagrant halt