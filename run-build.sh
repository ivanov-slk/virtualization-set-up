#!/usr/bin/bash

rm -r /home/slav/VirtualBox\ VMs/packer-ubuntu-20.04-amd64/
packer hcl2_upgrade ubuntu2004.json
PACKER_LOG=1 packer build ubuntu2004.json.pkr.hcl
vagrant up