terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "namespace_argocd" {
  yaml_body = file("./argocd/namespace-argocd.yaml")
}

data "http" "argocd_yaml_raw" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml"
}

data "kubectl_file_documents" "argocd_install_manifests" {
  content = data.http.argocd_yaml_raw.body
}

resource "kubectl_manifest" "argocd_install_manifests" {
  for_each  = data.kubectl_file_documents.argocd_install_manifests.manifests
  yaml_body = each.value
}

resource "kubectl_manifest" "argocd_lb" {
  yaml_body = file("./argocd/argocd-service-lb.yaml")

  depends_on = [kubectl_manifest.argocd_install_manifests]
}


