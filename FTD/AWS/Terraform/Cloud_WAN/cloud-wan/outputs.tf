output "ftd_private_ips" {
  description = "Private IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

output "ftd_public_ips" {
  description = "Public IP address of the FTD instances"
  value       = module.service_network.aws_ftd_eip
}