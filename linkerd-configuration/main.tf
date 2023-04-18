terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "tls_private_key" "linkerd_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd_ca" {
  private_key_pem       = tls_private_key.linkerd_ca.private_key_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 87600
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
  subject {
    common_name = "root.linkerd.cluster.local"
  }
}

resource "tls_private_key" "linkerd_issuer" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "linkerd_issuer" {
  private_key_pem = tls_private_key.linkerd_issuer.private_key_pem
  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_locally_signed_cert" "linkerd_issuer" {
  cert_request_pem      = tls_cert_request.linkerd_issuer.cert_request_pem
  ca_private_key_pem    = tls_private_key.linkerd_ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.linkerd_ca.cert_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 8760
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "kubectl_manifest" "namespace_linkerd" {
  yaml_body = file("./linkerd-configuration/namespace-linkerd.yaml")
}

resource "helm_release" "linkerd_crds" {
  name             = "linkerd-crds"
  namespace        = kubectl_manifest.namespace_linkerd.name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-crds"
  create_namespace = true
}

resource "helm_release" "linkerd_cni" {
  name             = "linkerd-cni"
  namespace        = kubectl_manifest.namespace_linkerd.name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd2-cni"
  create_namespace = false

  depends_on = [helm_release.linkerd_crds]
}

resource "helm_release" "linkerd_control_plane" {
  name             = "linkerd-control-plane"
  namespace        = kubectl_manifest.namespace_linkerd.name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-control-plane"
  create_namespace = false
  set {
    name  = "cniEnabled"
    value = "false"
  }
  set {
    name  = "identityTrustAnchorsPEM"
    value = tls_locally_signed_cert.linkerd_issuer.ca_cert_pem
  }
  set {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.linkerd_issuer.cert_pem
  }
  set {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.linkerd_issuer.private_key_pem
  }

  depends_on = [helm_release.linkerd_cni]
}

resource "helm_release" "linkerd_viz" {
  name             = "linkerd-viz"
  namespace        = kubectl_manifest.namespace_linkerd.name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-viz"
  create_namespace = false

  values = [
    "${file("./linkerd-configuration/linkerd-viz-values.yaml")}"
  ]

  depends_on = [helm_release.linkerd_control_plane]
}

resource "kubectl_manifest" "linkerd-web-lb" {
  yaml_body = file("./linkerd-configuration/linkerd-service-lb.yaml")

  depends_on = [helm_release.linkerd_viz]
}

# Needs to be executed only once, and does not need to be managed by Terraform, therefore the local exec.
# TODO Consider using something less ad hoc. 
resource "null_resource" "web_deployment_patch" {
  provisioner "local-exec" {
    command = "kubectl patch deployment web -n linkerd --patch-file linkerd-configuration/web-deployment-patch.yaml"
  }

  depends_on = [helm_release.linkerd_viz]
}

