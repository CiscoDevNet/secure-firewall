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