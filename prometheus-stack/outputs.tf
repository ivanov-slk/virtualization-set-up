output "prometheus-metadata" {
  description = "The details of the Helm chart used to deploy the Prometheus stack."
  value       = helm_release.kube_prometheus_stack
}
