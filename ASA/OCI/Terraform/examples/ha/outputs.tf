output "networks_map" {
  value       = module.asa-1.networks_map
  description = "map of networks"
}

output "networks_list" {
  value       = module.asa-1.networks_list
  description = "list of networks"
}

output "vm_external_ips" {
  value       = module.asa-1.vm_external_ips
  description = "external ips for VPC networks"
}
output "vm_private_ips" {
  value       = module.asa-1.vm_private_ips
  description = "Private IPs of created instances. "
}

output "external_lb_ip" {
  description = "The external ip address of the public load balancer"
  value       = module.asa-1.external_lb_ip
}


output "internal_lb_ip" {
  description = "The internal ip address of the private load balancer"
  value       = module.asa-1.internal_lb_ip
}