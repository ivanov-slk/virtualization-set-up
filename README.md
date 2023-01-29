# virtualization-set-up

## Description

A `terraform` repository for provisioning a virtual kubernetes cluster on VirtualBox.

## Components

### `packer` virtual machine images

Packer is used to create a Ubuntu server virtual machine image for `vagrant` (.box file) with a basic stack of packages.

### Kubernetes cluster

Provisions a Kubernetes cluster in VirtualBox with the desired configuration. The virtual machines are provisioned with `vagrant`. The Kubernetes cluster is configured with `Ansible`. Terraform manages these resources.

At this point, `vagrant` cannot be used to manage the virtual machines unless the environment variables for the VMI name and the SSH private key are explicitly set.

- i.e., if you want to `ssh` in a machine, you need to `export virtual_machine=""` and `export private_key_path=""` first and then `vagrant ssh vmi-name`.
- check [this issue](https://github.com/bmatcuk/terraform-provider-vagrant/issues/21) for more information.

### MetalLB

[MetalLB](https://metallb.universe.tf/) is needed so that an external IP of the kubernetes cluster can be used; otherwise `NodePort`s should be used, which is inconvenient. Installed via Helm.

### Istio

[Istio Service Mesh](https://istio.io/latest/) is installed using the latest available Helm charts.

### Kubernetes dashboard

The cluster comes with the Kubernetes dashboard installed. It can be accessed through a NodePort on port 30002 and with a token that is fetched using `kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')`.
Alternatively, a host (`kubernetes-dashboard.my-cluster.local`) can be specified in `/etc/hosts` and used in browser.

## Usage

You need to have Packer, Vagrant, Terraform, Ansible, Helm and VirtualBox installed.
Run `terraform init && terraform plan` to get an idea of what will be executed. It is recommended to run `terraform apply -target=module.[...]` in the order the components are listed above. `terraform destroy` will destroy all resources, cleaning up VirtualBox machines as well.

## Ideas

- move `packer` variables to somewhere else; they are hardcoded and essentially duplicated;
- explore Terragrunt;
- check ways for moving the loop outside of the Vagrantfile. Currently it is needed there because machines (apparently) _need_ to be created sequentially, and Terraform doesn't have a good way to sequentialize resources with `count` or `for_each`. Check [this SO answer](https://stackoverflow.com/a/64749410/10785101) for a suggested (and not especially neat) approach.
- check ways for alternative version specification; the current approach relies too much on the format of `CHANGES.md`.
- add removing of virtual boxes on destroying the k8s cluster; otherwise `vagrant` uses the old virtualboxes despite `packer` creating new ones.

## Task list

- Use latest Ubuntu server image;
- Deploy `linkerd` instead of `istio`;
- Ensure latest Kubernetes is running;
- Add modules to Terraform;
- Tests?

## Random notes

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
