# Changelog

---

# v0.13.0

### New

- Add ArgoCD to available services;
- Enable Prometheus metrics for ArgoCD;
- Add Grafana dashboard for ArgoCD.

---

# v0.12.1

### Bugfixes

- Skip first line of `kubectl get ...` when restarting resources.

---

# v0.12.0

### New

- Add Prometheus configuration for monitoring Strimzi Kafka clusters;
- Add Grafana dashboards for monitoring Strimzi Kafka clusters.

### Maintenance

- Update the Readme with details about Prometheus and Grafana;
- Move the post-provisioning step in a stand-alone script;

---

# v0.11.0

### New

- Add Prometheus and Grafana;
- Integrate with Linkerd.

### Maintenance

- Tag check now sorts tags correctly.

---

# v0.10.2

### Maintenance

- Reorder steps, so `linkerd` is provisioned before `metallb`.

---

# v0.10.1

### Maintenance

- Update readme and notes with information about Linkerd.

---

# v0.10.0

### New

- Provision `linkerd` as a service mesh provider.
- Inject `linkerd` in the Kubernetes Dashboard namespace.
- Inject `linkerd` in the MetalLB namespace.

---

# v0.9.0

### New

- Remove bridged adapter;
- Add explicit configuration for NAT.

### Maintenance

- Use the latest version of the Kuberentes Dashboard.

---

# v0.8.0

### New

- Add bridged adapter to VMs.

### Maintenance

- Now using Ubuntu Server 22.10 for `packer` builds;
- Kubernetes cluster configured to use Ubuntu Server 22.10 and Kubernetes 1.26;
- Add default values to `Vagrantfile` so that it could be run independently from Terraform;
- Update `containerd` installation due to issues, check README.md for more information;
- Fully migrate to `cloud-init` for Ubuntu unattended installation;

---

# v0.7.0

### New

- Access to the Kubernetes Dashboard now configured through Istio on host `kubernetes-dashboard.my-cluster.local`.

---

# v0.6.0

### New

- Added MetalLB and an external IP for accessing the cluster;
- Added Istio service mesh.

---

# v0.5.1

### Bugfixes

- Updated actions due to CHANGES.md format change.

---

# v0.5.0

### New

- Added the Kubernetes dashboard:
  - a separate Terraform module created (`kubernetes-dashboard`);
  - the Kubernetes resources are deployed in a separate namespace;
  - All YAML files are available in `./kubernetes-dashboard/manifests`.

---

# v0.4.0

### New

- Added Terraform module for managing the Kubernetes cluster;
- Added Ansible playbooks for configuring the Kubernetes cluster;
- Kubernetes module now manages the virtual machines as well; module `virtual-machine-instance` is removed as unnecessary anymore.

### Maintenance

- Extended the virtual machine storage to support Kubernetes requirements.

---

# v0.3.0

### New

- Moved Packer and Vagrant configurations in separate Terraform modules;
- Added documentation.

---

# v0.2.0

### New

- Parameterized the packer build;
- Added parameters to the Vagrantfile;
- Introduced Terraform to call `vagrant`.

### Bugfixes

- Fixed bugs in the tagging check.

---

# v0.1.1

### Bugfixes

- Fix github tag action's `on` condition.

---

# v0.1.0

### New

- Added GitHub actions.
