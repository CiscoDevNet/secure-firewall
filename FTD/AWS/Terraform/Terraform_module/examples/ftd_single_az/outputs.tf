 
output "service_mgmt_subnets" {
  value = module.network.mgmt_subnet
   
}

output "instance_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.instance.instance_public_ip
}