output "argocd-metadata" {
  description = "The details of the Helm chart used to deploy ArgoCD."
  value       = helm_release.kube_prometheus_stack
}
