output "argocd-metadata" {
  description = "The details of the manifests used to deploy ArgoCD."
  value       = helm_release.argocd
}
