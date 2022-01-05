#!/usr/bin/bash

# remove unneeded files
rm -r /home/slav/VirtualBox\ VMs/packer-ubuntu-20.04-amd64/
rm -r .vagrant || true
rm -r *.box || true

set -e
# packer
packer hcl2_upgrade ubuntu2004.json
PACKER_LOG=1 packer build ubuntu2004.json.pkr.hcl

# vagrant
vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove -f
vagrant up