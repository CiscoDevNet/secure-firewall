output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = resource.aws_ec2_transit_gateway.tgw[0].id
}