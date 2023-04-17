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

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd-system"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = false

}

resource "kubectl_manifest" "argocd_lb" {
  yaml_body = file("./argocd/argocd-service-lb.yaml")

  depends_on = [helm_release.argocd]
}


