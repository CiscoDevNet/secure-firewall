output "networks_map" {
  value       = module.networking.networks_map
  description = "map of networks"
}

output "vm_external_ips" {
  value       = module.vm.external_ips
  description = "external ips for vm"
}

output "external_lb_ip" {
  description = "The external ip address of the load balancer"
  value       = try(module.lb-1[0].external_ip_ext_fr, null)
}


output "internal_lb_ip" {
  description = "The internal ip address of the load balancer"
  value       = try(module.lb-1[0].internal_ip_ext_fr, null)
}
