terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# Ugly... need to change to strict ARP per https://metallb.universe.tf/installation/
resource "null_resource" "set_strict_arp" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e 's/strictARP: false/strictARP: true/' | kubectl apply -f - -n kube-system"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e 's/strictARP: true/strictARP: false/' | kubectl apply -f - -n kube-system"
  }
}
