output "virtual_machine_names" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = vagrant_vm.ubuntu-server-instance[*].machine_names[0]
}

output "virtual_machine_ports" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = vagrant_vm.ubuntu-server-instance[*].ports[0][0].host
}