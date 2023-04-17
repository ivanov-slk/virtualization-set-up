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

  depends_on = [kubectl_manifest.namespace_argocd]
}

resource "kubectl_manifest" "grafana_argocd_dashboard" {
  yaml_body = file("./argocd/prometheus-configurations/grafana-argocd-dashboard.yaml")
}

data "kubectl_filename_list" "prometheus_argocd_service_monitors" {
  pattern = "./argocd/prometheus-configurations/service-monitor-*.yaml"
}

resource "kubectl_manifest" "prometheus_argocd_service_monitors" {
  count     = length(data.kubectl_filename_list.prometheus_argocd_service_monitors.matches)
  yaml_body = file(element(data.kubectl_filename_list.prometheus_argocd_service_monitors.matches, count.index))
}

resource "kubectl_manifest" "argocd_lb" {
  yaml_body = file("./argocd/argocd-service-lb.yaml")

  depends_on = [helm_release.argocd]
}


