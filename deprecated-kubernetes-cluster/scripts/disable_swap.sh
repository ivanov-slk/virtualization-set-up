#! /usr/bin/bash
set -e

sudo swapoff -a

# Disable swap on startup
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
