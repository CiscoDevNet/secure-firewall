output "networks_list" {
  value       = local.networks_list
  description = "A list of network related info such as name, links,subnet links, cir, internal IP, has external IP or not etc"
}

output "subnet_self_link_fmc" {
  value       = module.vpc-module[var.mgmt_network].subnets_self_links[0]
  description = "subnet self link of management network"
}
 