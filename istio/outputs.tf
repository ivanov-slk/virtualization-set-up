output "istio_latest" {
    description = "The latest version of Istio."
    value       = data.external.get_latest_istio_version.result.istio_latest
}