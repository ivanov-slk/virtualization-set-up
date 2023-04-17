output "argocd-metadata" {
  description = "The details of the manifests used to deploy ArgoCD."
  value       = kubectl_manifest.argocd_install_manifests[*].kind
}
