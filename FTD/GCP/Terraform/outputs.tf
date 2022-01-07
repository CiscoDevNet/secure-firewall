output "networks_list" {
  value       = module.networking.networks_list
  description = "list of networks"
}

output "vm_external_ips" {
  value       = module.vm.external_ips
  description = "external ips for vm"
}