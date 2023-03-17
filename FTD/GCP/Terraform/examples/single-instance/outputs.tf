output "networks_list" {
  value       = module.ftd-1.networks_list
  description = "list of networks"
}

output "vm_external_ips" {
  value       = module.ftd-1.vm_external_ips
  description = "external ips for VPC networks"
}