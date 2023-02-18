terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "namespace" {
  yaml_body = file("./kubernetes-dashboard/manifests/namespace.yaml")
}

resource "kubectl_manifest" "cluster-role-binding" {
  yaml_body = file("./kubernetes-dashboard/manifests/cluster-role-binding.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "cluster-role-binding-np" {
  yaml_body = file("./kubernetes-dashboard/manifests/cluster-role-binding-np.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "cluster-role" {
  yaml_body = file("./kubernetes-dashboard/manifests/cluster-role.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "configmap" {
  yaml_body = file("./kubernetes-dashboard/manifests/configmap.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "deployment-dashboard" {
  yaml_body = file("./kubernetes-dashboard/manifests/deployment-dashboard.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "deployment-metrics" {
  yaml_body = file("./kubernetes-dashboard/manifests/deployment-metrics.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "role-binding" {
  yaml_body = file("./kubernetes-dashboard/manifests/role-binding.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "role" {
  yaml_body = file("./kubernetes-dashboard/manifests/role.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "secret-certs" {
  yaml_body = file("./kubernetes-dashboard/manifests/secret-certs.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "secret-csrf" {
  yaml_body = file("./kubernetes-dashboard/manifests/secret-csrf.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "secret-key-holder" {
  yaml_body = file("./kubernetes-dashboard/manifests/secret-key-holder.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-account" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-account.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-account-np" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-account-np.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-dashboard" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-dashboard.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-dashboard-lb" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-dashboard-lb.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-np-dashboard" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-np-dashboard.yaml")

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "service-metrics" {
  yaml_body = file("./kubernetes-dashboard/manifests/service-metrics.yaml")

  depends_on = [kubectl_manifest.namespace]
}

# resource "kubectl_manifest" "istio-gateway" {
#   yaml_body = file("./kubernetes-dashboard/manifests/istio-gateway.yaml")

#   depends_on = [kubectl_manifest.namespace, kubectl_manifest.service-dashboard]
# }

# resource "kubectl_manifest" "istio-virtual-service" {
#   yaml_body = file("./kubernetes-dashboard/manifests/istio-virtual-service.yaml")

#   depends_on = [kubectl_manifest.namespace, kubectl_manifest.service-dashboard, kubectl_manifest.istio-gateway]
# }
