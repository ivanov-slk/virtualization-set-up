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

### Kubernetes dashboard

The cluster comes with the Kubernetes dashboard installed. It can be accessed through a NodePort on port 30002 and with a token that is fetched using `kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')`.

## Usage

You need to have Packer, Vagrant, Terraform, Ansible and VirtualBox installed.
Run `terraform init && terraform plan` to get an idea of what will be executed. `terraform apply` it and you will get a working kubernetes cluster in minutes. `terraform destroy` will destroy all resources, cleaning up VirtualBox as well.

## TO-DO

- move `packer` variables to somewhere else; they are hardcoded and essentially duplicated;
- explore Terragrunt;
- check ways for moving the loop outside of the Vagrantfile. Currently it is needed there because machines (apparently) _need_ to be created sequentially, and Terraform doesn't have a good way to sequentialize resources with `count` or `for_each`. Check [this SO answer](https://stackoverflow.com/a/64749410/10785101) for a suggested (and not especially neat) approach.
