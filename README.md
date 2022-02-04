# virtualization-set-up

## Description

A `terraform` repository for provisioning a virtual kubernetes cluster on VirtualBox.

## Components

### `packer` virtual machine images

Packer is used to create a Ubuntu server virtual machine image for `vagrant` (.box file) with a basic stack of packages.

### Kubernetes cluster

Provisions a Kubernetes cluster in VirtualBox with the desired configuration. The virtual machines are provisioned with `vagrant`. The Kubernetes cluster is configured with `Ansible`. Terraform manages these resources.

### Usage

You need to have Packer, Vagrant, Terraform and VirtualBox installed.
Run `terraform init && terraform plan` to get an idea of what will be executed. `terraform apply` it and you will get a working kubernetes cluster in minutes. `terraform destroy` will destroy all resources, cleaning up VirtualBox as well.

## TO-DO

- move `packer` variables to somewhere else; they are hardcoded and essentially duplicated;
- explore Terragrunt;
- check ways for moving the loop outside of the Vagrantfile. Currently it is needed there because machines (apparently) _need_ to be created sequentially, and Terraform doesn't have a good way to sequentialize resources with `count` or `for_each`. Check [this SO answer](https://stackoverflow.com/a/64749410/10785101) for a suggested (and not especially neat) approach.
