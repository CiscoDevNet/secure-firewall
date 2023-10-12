output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = module.service_network.internet_gateway
}
output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.transitgateway.transit_gateway_id
}
output "subnet_A_id" {
  description = "ID of subnet in VPC-A"
  value       = module.spoke_network.outside_subnet
}
output "subnet_B_id" {
  description = "ID of subnet in VPC-B"
  value       = module.spoke_network_2.outside_subnet
}