# virtualization-set-up

## Description

## Components

### `packer` virtual machine images

### Virtual Box cluster

- NB: before you execute `vagrant` commands in a shell, you need to explicitly set the environment variables for the VMI name and the SSH private key due to vagrant environment variables not being present in the shell you would run `vagrant ...` commands from.
  - i.e., if you want to `ssh` in a machine, you need to `export virtual_machine_master=""` and `export private_key_path_master=""` first and then `vagrant ssh vmi-name`.
  - check [this issue](https://github.com/bmatcuk/terraform-provider-vagrant/issues/21) for more information.

## TO-DO

- move `packer` variables to somewhere else; they are hardcoded and essentially duplicated.
