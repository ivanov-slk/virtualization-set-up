output "virtual_machine_configuration" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = zipmap(vagrant_vm.kubernetes-cluster[*].machine_names[0], vagrant_vm.kubernetes-cluster[*].ports[0][0].host)
}

output "virtual_machine_names" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = vagrant_vm.kubernetes-cluster[*].machine_names[0]
}

output "virtual_machine_ports" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = vagrant_vm.kubernetes-cluster[*].ports[0][0].host
}