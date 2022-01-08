output "vm_external_ips" {
  value       = module.vm.external_ips
  description = "external ips for vm"
}

output "subnet_name" {
  value       = local.subnet_name
  description = "subnet name"
}