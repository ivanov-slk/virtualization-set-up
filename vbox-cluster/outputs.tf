output "virtual_machine_names" {
    description = "The names of the Vagrant-created VirtualBox machines."
    value       = module.vbox-cluster.machine_names
}

output "virtual_machine_ports" {
    description = "The exposed ports of the Vagrant-created VirtualBox machines."
    value       = module.vbox-cluster.ports
}