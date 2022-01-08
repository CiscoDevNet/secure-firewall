output "subnet_self_link" {
  value       = module.vpc-module.subnets_self_links[0]
  description = "subnet self link of management network"
}

output "subnet_name" {
  value       = module.vpc-module.subnets_names[0]
  description = "subnet self link of management network"
}