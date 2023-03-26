## Development notes

### Task list

- Deploy `linkerd` instead of `istio`;
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
- Tried `sudo tcpdump -i enp0s8 host 192.168.56.46 -vv` on both `worker-4` and `master-1`, which are the only active nodes:
  ```
  tcpdump: listening on enp0s9, link-type EN10MB (Ethernet), snapshot length 262144 bytes
  19:13:41.295688 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  19:13:42.315033 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  19:13:43.338968 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has kubernetes-dashboard.my-cluster.local tell Slav-PC, length 46
  ```
  - The requests are coming in, but they get dropped or something.
  - Tried all active network interfaces, but only on `enp0s9` (the bridged adapter) traffic comes in.
- Turned on promiscuous mode `sudo ifconfig enp0s8 promisc` on both nodes and tried `tcpdump` again, same results.
- If I do the `curl` command from `worker-4` (where the dashboard is deployed), I get success, but nothing in `tcpdump`.
- Tried [this SO answer](https://serverfault.com/a/125500); value is 0 for both nodes, which seems ok.
- Checked `/etc/hosts.allow` and `/etc/hosts.deny` on both nodes, no rules there.
- Tried setting `externalTrafficPolicy: Local` in the k8s service, no success;
- Tried removing the strict ARP resource (apparently needed only when using IPVS); same thing;
- Set log level to `all` in the DS, seeing debug messages, but nothing useful;
- I can connect to the nodes, though, so the host machine knows about them and how to access them.
- `tcpdump`-ing the gateway (`192.168.56.1`) shows the same results - ARP requests, but no replies. The master's `tcpdump` shows more traffic; on the workers only ARP appears.
- Tried configuring BGP using some default configurations, same result - internally it works, from host - no.
- Tried setting kube-proxy to IPVS, same result; same with also enabling promiscuous mode on `enp0s8`.
- Recreated the cluster with the latest settings (IPVS, gateway 192.168.56.1 for host-only network). The behavior now is a bit different (the below output is seen only on master, `tcpdump` on workers is silent):

```
vagrant@master-1:~$ sudo tcpdump -i enp0s8 host 192.168.56.46 -vv
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
06:03:29.834424 IP (tos 0x0, ttl 64, id 51942, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.52868 > master-1.https: Flags [S], cksum 0x62c0 (correct), seq 581808951, win 64240, options [mss 1460,sackOK,TS val 2385626232 ecr 0,nop,wscale 7], length 0
06:03:52.883432 IP (tos 0x0, ttl 64, id 16155, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.37884 > master-1.https: Flags [S], cksum 0xf565 (correct), seq 134224830, win 64240, options [mss 1460,sackOK,TS val 2385649281 ecr 0,nop,wscale 7], length 0
06:03:53.898432 IP (tos 0x0, ttl 64, id 16156, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.37884 > master-1.https: Flags [S], cksum 0xf16e (correct), seq 134224830, win 64240, options [mss 1460,sackOK,TS val 2385650296 ecr 0,nop,wscale 7], length 0
06:03:55.914412 IP (tos 0x0, ttl 64, id 16157, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.37884 > master-1.https: Flags [S], cksum 0xe98e (correct), seq 134224830, win 64240, options [mss 1460,sackOK,TS val 2385652312 ecr 0,nop,wscale 7], length 0
06:03:57.994345 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has master-1 tell _gateway, length 46
06:03:57.994368 ARP, Ethernet (len 6), IPv4 (len 4), Reply master-1 is-at 08:00:27:96:6b:0b (oui Unknown), length 28
06:04:00.042448 IP (tos 0x0, ttl 64, id 16158, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.37884 > master-1.https: Flags [S], cksum 0xd96e (correct), seq 134224830, win 64240, options [mss 1460,sackOK,TS val 2385656440 ecr 0,nop,wscale 7], length 0
06:04:08.234394 IP (tos 0x0, ttl 64, id 16159, offset 0, flags [DF], proto TCP (6), length 60)
    _gateway.37884 > master-1.https: Flags [S], cksum 0xb96e (correct), seq 134224830, win 64240, options [mss 1460,sackOK,TS val 2385664632 ecr 0,nop,wscale 7], length 0
```

- Changing `externalTrafficPolicy` from `Local` to `Cluster` in the `LoadBalancer` service resolved the problem.

- https://www.practicalnetworking.net has good materials on networking.
- [Good resource](https://danielmiessler.com/study/tcpdump/) on using `tcpdump`.
- [On `/proc`](https://wizardzines.com/comics/proc/).

### Fixing large memory usage

- Apparently due to [caching](https://www.virtualbox.org/manual/ch05.html#iocaching) by VirtualBox.
- Old example [here](https://gist.github.com/eloycoto/abfe35b8936bf728494e).

### Fixing Calico nodes occasionally entering crash loops

- The error is:
  - `2023-03-11 10:59:22.772 [ERROR][79] felix/health.go 360: Health endpoint failed, trying to restart it... error=listen tcp: lookup localhost on 8.8.8.8:53: no such host`
  - it appears kind of randomly when I recreate the cluster;
- Tried [setting IP autodetection method](https://docs.tigera.io/archive/v3.8/reference/node/configuration#ip-setting) with interface, but only `enp0s8` got as far as not setting autodetection manually. The other options (`enp0s3,enp0s8` or `enp0s3`) I tried resulted in earlier errors.
  - Similar information [here](https://github.com/projectcalico/calico/issues/2042).
- Tried setting the localhost for the probes and it worked.
  - Reference [here](https://github.com/projectcalico/calico/issues/6963#issuecomment-1307930491).
  - It seems more like a patch instead of a solution though.
- It seems there are various ways to configure Felix, as per their [documentation](https://docs.tigera.io/calico/3.25/reference/felix/configuration). However, automating the addition of `FELIX_HEALTHHOST` seems clumsy with them. The easiest approach would be to use `kubectl patch` with a patch file, or even easier with `kubectl set env daemonset/calico-node FELIX_HEALTHHOST="127.0.0.1"`.
  - Finally (2023-03-19), the patch was implemented in Ansible and this seems to resolve the issue.
