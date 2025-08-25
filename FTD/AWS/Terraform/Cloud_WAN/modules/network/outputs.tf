# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.ftd_vpc.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = var.vpc_cidr
}
output "mgmt_interface" {
  description = "Mgmt interface id"
  value       = aws_network_interface.ftd_mgmt.*.id
}

output "outside_interface" {
  description = "Outside interface id"
  value       = aws_network_interface.ftd_outside.*.id
}

output "inside_interface" {
  description = "Inside interface id"
  value       = aws_network_interface.ftd_inside.*.id
}

output "diag_interface" {
  description = "Diag interface id"
  value       = aws_network_interface.ftd_diag.*.id
}

output "mgmt_subnet" {
  description = "Mgmt Subnet id"
  value       = aws_subnet.mgmt_subnet.*.id
}

output "inside_subnet" {
  description = "Inside Subnet id"
  value       = aws_subnet.inside_subnet.*.id
}

output "outside_subnet" {
  description = "Outside Subnet id"
  value       = aws_subnet.outside_subnet.*.id
}

output "diag_subnet" {
  description = "Diag Subnet id"
  value       = local.diag_subnet
}

output "outside_subnet_cidr" {
  description = "Outside Subnet CIDR"
  value       = local.outside_subnet
}

output "mgmt_interface_ip" {
  description = "Mgmt Interface IP"
  value       = aws_network_interface.ftd_mgmt.*.private_ip
}

output "inside_interface_ip" {
  description = "Inside Interface IP"
  value       = aws_network_interface.ftd_inside.*.private_ip
}

output "outside_interface_ip" {
  description = "outside Interface IP"
  value       = aws_network_interface.ftd_outside.*.private_ip
}

output "diag_interface_ip" {
  description = "Diag Interface IP"
  value       = aws_network_interface.ftd_diag.*.private_ip
}

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.int_gw.id
}

output "outside_rt_id" {
  description = "Outside subnet Route table ID"
  value       = aws_route_table.ftd_outside_route.*.id
}

output "mgmt_rt_id" {
  description = "Mgmt subnet Route table ID"
  value       = aws_route_table.ftd_mgmt_route.*.id
}

output "aws_ftd_eip" {
  value = var.use_ftd_eip ? aws_eip.ftd_mgmt_eip.*.public_ip : null
}