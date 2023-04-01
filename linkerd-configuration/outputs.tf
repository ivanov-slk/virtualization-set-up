output "linkerd-dashboard-metadata" {
  description = "The details of the Helm chart used to deploy the dashboard of Linkerd."
  value       = helm_release.linkerd_viz
}
