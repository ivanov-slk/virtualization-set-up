resource "time_sleep" "post_provisioning_grace_period" {
  create_duration = "1m"
}

# TODO Refactor, this depends on resources in other modules and is error-prone.
# Restart all pods to have linkerd start tracking them.
resource "null_resource" "restart_prometheus_stack" {
  provisioner "local-exec" {
    command = "bash ./post-provisioning/restart-kubernetes-resources.sh"
  }

  depends_on = [time_sleep.post_provisioning_grace_period]
}
