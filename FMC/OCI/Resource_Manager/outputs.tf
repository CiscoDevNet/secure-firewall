
output "subnet_id" {
  value       = local.subnet_id
  description = "subnet id"
}
output "vm_external_ips" {
  value       = module.vm.external_ips
  description = "external ips for created instances."
}

output "vm_private_ips" {
  value       = module.vm.private_ips
  description = "Private IPs of created instances. "
}