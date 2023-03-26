terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# Now set during setting up the Kubernetes cluster.
# # Ugly... need to change to strict ARP per https://metallb.universe.tf/installation/
# resource "null_resource" "set_strict_arp" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e 's/strictARP: false/strictARP: true/' | kubectl apply -f - -n kube-system"
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = "kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e 's/strictARP: true/strictARP: false/' | kubectl apply -f - -n kube-system"
#   }
# }

resource "kubectl_manifest" "metallb_namespace" {
  yaml_body = file("./metallb-configuration/namespace-metallb.yaml")

  # depends_on = [null_resource.set_strict_arp]
}

resource "kubectl_manifest" "metallb_configuration_crds" {
  yaml_body = file("./metallb-configuration/configuration-crds-metallb.yaml")

  depends_on = [kubectl_manifest.metallb_namespace, helm_release.metallb]
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "metallb-system"

  depends_on = [kubectl_manifest.metallb_namespace]
}


