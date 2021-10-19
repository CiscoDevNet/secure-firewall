output "networks_map" {
  value       = module.asa-1.networks_map
  description = "map of networks"
}

output "network_names" {
  value       = keys(module.asa-1.networks_map)
  description = "The names of the VPC networks being created"
}
output "vm_external_ips" {
  value       = module.asa-1.vm_external_ips
  description = "external ips for VPC networks"
}