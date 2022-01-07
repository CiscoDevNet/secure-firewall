output "networks_map" {
  value       = local.networks_map
  description = "A map of network related info such as name, links,subnet links, cir, internal IP, has external IP or not etc"
}

output "networks_list" {
  value       = local.networks_list
  description = "A list of network related info such as name, links,subnet links, cidr, internal IP, has external IP or not etc"
}