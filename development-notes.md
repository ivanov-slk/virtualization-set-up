## Development notes

### Task list

- Use latest Ubuntu server image;
- Deploy `linkerd` instead of `istio`;
- Ensure latest Kubernetes is running;
- Add modules to Terraform;
- Tests?

### Update to `containerd` `config.toml`

- Branch `use-latest-ubuntu-server-image`; check commit log and links for more details.
- Ubuntu 22.04 _apparently_ introduced a change that broke the `cgroup` driver configuration and the previous `containerd` configuration stopped working. What does work is forcing `containerd` to use `systemd`'s `cgroup` driver.
  - https://github.com/kubernetes/kubernetes/issues/110177
  - https://github.com/containerd/containerd/issues/4203
  - https://github.com/kubernetes/kubeadm/issues/2449
  - https://github.com/containerd/containerd/issues/4581
  - https://github.com/containerd/containerd/blob/main/docs/cri/config.md
  - https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd
  - https://kubernetes.io/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver
  - https://kubernetes.io/docs/concepts/architecture/cgroups/#using-cgroupv2

### Debugging MetalLB not exposing the Kubernetes Dashboard

- Tried `bash ./kubetail -l app.kubernetes.io/component=speaker -n metallb-system` and did `curl -kv https://192.168.56.46/#/workloads?namespace=default`; got:

```
Will tail 2 logs...
metallb-speaker-2zj7t
metallb-speaker-l4dr8
[metallb-speaker-l4dr8] W0301 19:14:42.866262       1 warnings.go:70] metallb.io v1beta1 AddressPool is deprecated, consider using IPAddressPool
[metallb-speaker-2zj7t] {"caller":"node_controller.go:42","controller":"NodeReconciler","level":"info","start reconcile":"/master-1","ts":"2023-03-01T19:15:36Z"}
[metallb-speaker-2zj7t] {"caller":"speakerlist.go:271","level":"info","msg":"triggering discovery","op":"memberDiscovery","ts":"2023-03-01T19:15:36Z"}
[metallb-speaker-2zj7t] {"caller":"node_controller.go:64","controller":"NodeReconciler","end reconcile":"/master-1","level":"info","ts":"2023-03-01T19:15:36Z"}
[metallb-speaker-l4dr8] {"caller":"node_controller.go:42","controller":"NodeReconciler","level":"info","start reconcile":"/worker-4","ts":"2023-03-01T19:15:51Z"}
[metallb-speaker-l4dr8] {"caller":"speakerlist.go:271","level":"info","msg":"triggering discovery","op":"memberDiscovery","ts":"2023-03-01T19:15:51Z"}
[metallb-speaker-l4dr8] {"caller":"node_controller.go:64","controller":"NodeReconciler","end reconcile":"/worker-4","level":"info","ts":"2023-03-01T19:15:51Z"}
```

- These look like pretty standard logs; it doesn't look that they appear when I execute the `curl` command.
- Tried `sudo tcpdump -i enp0s9 host 192.168.56.46 -vv` on both `worker-4` and `master-1`, which are the only active nodes:
  ```
  tcpdump: listening on enp0s9, link-type EN10MB (Ethernet), snapshot length 262144 bytes
  19:13:41.295688 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  19:13:42.315033 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  19:13:43.338968 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  ```
  - The requests are coming in, but they get dropped or something.
  - Tried all active network interfaces, but only on `enp0s9` (the bridged adapter) traffic comes in.
- Turned on promiscuous mode `sudo ifconfig enp0s9 promisc` on both nodes and tried `tcpdump` again, same results.
- If I do the `curl` command from `worker-4` (where the dashboard is deployed), I get success, but nothing in `tcpdump`.
- Tried [this SO answer](https://serverfault.com/a/125500); value is 0 for both nodes, which seems ok.