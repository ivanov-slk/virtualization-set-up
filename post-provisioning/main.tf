resource "time_sleep" "post_provisioning_grace_period" {
  create_duration = "1m"
}

# TODO Refactor, this depends on resources in other modules and is error-prone.
# Restart all pods to have linkerd start tracking them.
resource "null_resource" "restart_prometheus_stack" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      kubectl rollout restart deployment kube-prometheus-stack-grafana -n prometheus
      kubectl rollout restart deployment kube-prometheus-stack-kube-state-metrics -n prometheus
      kubectl rollout restart deployment kube-prometheus-stack-operator -n prometheus
      kubectl rollout restart ds kube-prometheus-stack-prometheus-node-exporter -n prometheus
    EOT
  }

  depends_on = [time_sleep.post_provisioning_grace_period]
}
