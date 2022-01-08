output "vm_external_ips" {
  value       = module.fmc-1.vm_external_ips
  description = "external ips for VPC networks"
}

output "subnet_name" {
  value       = module.fmc-1.subnet_name
  description = "subnet name"
}