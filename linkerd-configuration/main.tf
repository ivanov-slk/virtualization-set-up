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

resource "tls_locally_signed_cert" "issuer" {
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

resource "helm_release" "linkerd_cni" {
  name       = "linkerd-cni"
  namespace  = "linkerd-helm"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2-cni"
  #   version          = "2.11.4"
  create_namespace = true
}

resource "helm_release" "linkerd" {
  name       = "linkerd"
  namespace  = helm_release.linkerd_cni.namespace
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  #   version          = "2.11.4"
  create_namespace = false
  set {
    name  = "cniEnabled"
    value = "true"
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
}

resource "helm_release" "linkerd_viz" {
  name       = "linkerd-viz"
  namespace  = helm_release.linkerd_cni.namespace
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-viz"
  #   version          = "2.11.4"
  create_namespace = false
}
