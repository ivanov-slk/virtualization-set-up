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

  values = [
    "${file("./argocd/argocd-values.yaml")}"
  ]

  depends_on = [kubectl_manifest.namespace_argocd]
}

resource "kubectl_manifest" "grafana_argocd_dashboard" {
  yaml_body = file("./argocd/prometheus-configurations/grafana-argocd-dashboard.yaml")
}

# resource "kubectl_manifest" "applicationset_controller_metrics" {
#   yaml_body = file("./argocd/prometheus-configurations/service-monitor-argocd-metrics.yaml")
# }

# resource "kubectl_manifest" "metrics" {
#   yaml_body = file("./argocd/prometheus-configurations/service-monitor-argocd-redis-metrics.yaml")
# }

# resource "kubectl_manifest" "repo_server_metrics" {
#   yaml_body = file("./argocd/prometheus-configurations/service-monitor-argocd-repo-server-metrics.yaml")
# }

# resource "kubectl_manifest" "server_metrics" {
#   yaml_body = file("./argocd/prometheus-configurations/service-monitor-argocd-server-metrics.yaml")
# }

resource "kubectl_manifest" "argocd_lb" {
  yaml_body = file("./argocd/argocd-service-lb.yaml")

  depends_on = [helm_release.argocd]
}


