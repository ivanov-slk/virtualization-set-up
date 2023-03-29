terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "namespace_prometheus" {
  yaml_body = file("./prometheus-stack/namespace-prometheus.yaml")
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  namespace        = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = false

  values = [
    "${file("./prometheus-stack/prometheus-values.yaml")}"
  ]

  depends_on = [kubectl_manifest.namespace_prometheus, kubectl_manifest.namespace_monitoring]
}
