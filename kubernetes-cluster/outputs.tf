output "virtual_machine_configuration_master" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = zipmap(vagrant_vm.kubernetes-cluster-master[*].machine_names[0], vagrant_vm.kubernetes-cluster-master[*].ports[0][0].host)
}

output "virtual_machine_names_master" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = vagrant_vm.kubernetes-cluster-master[*].machine_names[0]
}

output "virtual_machine_ports_master" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = vagrant_vm.kubernetes-cluster-master[*].ports[0][0].host
}

output "virtual_machine_configuration_worker" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = zipmap(vagrant_vm.kubernetes-cluster-worker[*].machine_names[0], vagrant_vm.kubernetes-cluster-worker[*].ports[0][0].host)
}

output "virtual_machine_names_worker" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = vagrant_vm.kubernetes-cluster-worker[*].machine_names[0]
}

output "virtual_machine_ports_worker" {
  description = "The exposed ports of the Vagrant-created VirtualBox machines."
  value       = vagrant_vm.kubernetes-cluster-worker[*].ports[0][0].host
}
