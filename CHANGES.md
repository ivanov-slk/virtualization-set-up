# Changelog

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
