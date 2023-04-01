output "virtual-machine-instance-outputs" {
  description = "The outputs from the virtual-machine-instance module."
  value       = module.kubernetes-cluster
}

output "prometheus-metadata" {
  description = "The details of the Helm chart used to deploy the Prometheus stack."
  value       = module.prometheus-stack
  sensitive   = true
}

output "linkerd-dashboard-metadata" {
  description = "The details of the Helm chart used to deploy the dashboard of Linkerd."
  value       = module.linkerd
  sensitive   = true
}
