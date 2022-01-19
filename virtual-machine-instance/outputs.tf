output "virtual_machine_configuration" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = zipmap(vagrant_vm.ubuntu-server-instance[*].machine_names[0], vagrant_vm.ubuntu-server-instance[*].ports[0][0].host)
}