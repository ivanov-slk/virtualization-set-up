terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "external" "get_latest_istio_version" {
  program = ["bash", "./istio/get-latest-istio.sh"]
}

# Ugly...
resource "null_resource" "download_istio_charts" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    # command = "mkdir -p ./istio/istio-charts && cd ./istio/istio-charts && curl -L https://istio.io/downloadIstio | sh - && cd -"
    command = "ls"
  }

  provisioner "local-exec" {
    when = destroy
    # command = "rm -rf ./istio/istio-charts"
    command = "ls"
  }
}

resource "kubectl_manifest" "istio_namespace" {
  yaml_body = file("./istio/namespace-istio.yaml")

  depends_on = [null_resource.download_istio_charts]
}

resource "helm_release" "istio_base" {
  name  = "istio-base"
  chart = "./istio/istio-charts/istio-${data.external.get_latest_istio_version.result.istio_latest}/manifests/charts/base"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [kubectl_manifest.istio_namespace, null_resource.download_istio_charts]
}

resource "helm_release" "istiod" {
  name  = "istiod"
  chart = "./istio/istio-charts/istio-${data.external.get_latest_istio_version.result.istio_latest}/manifests/charts/istio-control/istio-discovery"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  chart = "./istio/istio-charts/istio-${data.external.get_latest_istio_version.result.istio_latest}/manifests/charts/gateways/istio-ingress"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [helm_release.istiod, helm_release.istio_egress]
}

resource "helm_release" "istio_egress" {
  name  = "istio-egress"
  chart = "./istio/istio-charts/istio-${data.external.get_latest_istio_version.result.istio_latest}/manifests/charts/gateways/istio-egress"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [helm_release.istiod]
}

