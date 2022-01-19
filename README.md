# virtualization-set-up

## Description

A `terraform` repository for provisioning a virtual kubernetes cluster on Virtual Box.

## Components

### `packer` virtual machine images

Packer is used to create a virtual machine image for `vagrant` (.box file) with a basic stack of packages for working as a kubernetes node.

### Virtual Box cluster

Provisions a Virtual Box cluster with the desired configuration.

- NB: before you execute `vagrant` commands in a shell, you need to explicitly set the environment variables for the VMI name and the SSH private key due to vagrant environment variables not being present in the shell you would run `vagrant ...` commands from.
  - i.e., if you want to `ssh` in a machine, you need to `export virtual_machine=""` and `export private_key_path=""` first and then `vagrant ssh vmi-name`.
  - check [this issue](https://github.com/bmatcuk/terraform-provider-vagrant/issues/21) for more information.

### Usage

You need to have Packer, Vagrant, Terraform and VirtualBox installed.
Run `terraform init && terraform plan` to get an idea of what will be executed. `terraform apply` it and you will get a working kubernetes cluster in minutes.

## TO-DO

- move `packer` variables to somewhere else; they are hardcoded and essentially duplicated.
