output "subnet_id" {
  value       = module.fmc-1.subnet_id
  description = "subnet_id"
}

output "vm_external_ips" {
  value       = module.fmc-1.vm_external_ips
  description = "external ips for created instances"
}

output "vm_private_ips" {
  value       = module.fmc-1.vm_private_ips
  description = "Private IPs of created instances. "
}