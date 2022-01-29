#! /usr/bin/bash
set -e

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# # Configure Docker options because of... something...
# echo "{\"exec-opts\": [\"native.cgroupdriver=systemd\"]}" | sudo tee /etc/docker/daemon.json
# sudo systemctl daemon-reload
# sudo systemctl restart docker
# sudo systemctl restart kubelet