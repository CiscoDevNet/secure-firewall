output "networks_map" {
  value       = module.networking.networks_map
  description = "map of networks"
}
output "networks_list" {
  value       = module.networking.networks_list
  description = "A list of network related info such as name, links,subnet links, cidr, internal IP, has external IP or not etc"
}

output "vm_external_ips" {
  value       = module.vm.external_ips
  description = "external ips for created instances."
}

output "vm_private_ips" {
  value       = module.vm.private_ips
  description = "Private IPs of created instances. "
}

output "external_lb_ip" {
  description = "The public ip address of the public load balancer"
  value       = try(module.lb-1[0].external_lb_ip, null)
}


output "internal_lb_ip" {
  description = "The private  ip address of the private load balancer"
  value       = try(module.lb-1[0].internal_lb_ip, null)
}
