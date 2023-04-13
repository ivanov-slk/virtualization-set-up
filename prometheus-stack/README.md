## Configuration of the Prometheus stack

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

The provisioning also includes monitoring configuration for the Strimzi Kafka operator and custom resources, as described in [Strimzi's documentation](https://strimzi.io/docs/operators/latest/deploying.html#assembly-metrics-prometheus-str). Grafana dashboards are also included as supplied by Strimzi - updated to support the latest Grafana version. The update was made by manually importing Strimzi's original JSON definitions into Grafana and then copying Grafana's updated JSON model and putting it in a configmap.

For reference, adding new Grafana dashboards is as easy as adding new `ConfigMap`s with the label `grafana_dashboard: "1"`, which forces it to be picked up by [Grafana's sidecar](https://github.com/kiwigrid/k8s-sidecar). Very convenient.
