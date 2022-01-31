output "vpc_id" {
  value = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
}

output "mgmt01_interface" {
  value = aws_network_interface.asa01_mgmt.id
}

output "mgmt02_interface" {
  value = aws_network_interface.asa02_mgmt.id
}

output "outside01_interface" {
  value = aws_network_interface.asa01_outside.id
}

output "outside02_interface" {
  value = aws_network_interface.asa02_outside.id
}

output "inside01_interface" {
  value = aws_network_interface.asa01_inside.id
}

output "inside02_interface" {
  value = aws_network_interface.asa02_inside.id
}

output "dmz01_interface" {
  value = aws_network_interface.asa01_dmz.id
}

output "dmz02_interface" {
  value = aws_network_interface.asa02_dmz.id
}

output "mgmt01_subnet" {
  value = var.mgmt01_subnet_cidr != null ? aws_subnet.mgmt01_subnet[0].id : data.aws_subnet.mgmt01[0].id
}

output "mgmt02_subnet" {
  value = var.mgmt02_subnet_cidr != null ? aws_subnet.mgmt02_subnet[0].id : data.aws_subnet.mgmt02[0].id
}

output "inside01_subnet" {
  value = var.inside01_subnet_cidr != null ? aws_subnet.inside01_subnet[0].id : data.aws_subnet.insideasa01[0].id
}

output "inside02_subnet" {
  value = var.inside02_subnet_cidr != null ? aws_subnet.inside02_subnet[0].id : data.aws_subnet.insideasa02[0].id
}

output "outside01_subnet" {
  value = var.outside01_subnet_cidr != null ? aws_subnet.outside01_subnet[0].id : data.aws_subnet.outsideasa01[0].id
}

output "outside02_subnet" {
  value = var.outside02_subnet_cidr != null ? aws_subnet.outside02_subnet[0].id : data.aws_subnet.outsideasa02[0].id
}


output "mgmt01_interface_ip" {
  value = aws_network_interface.asa01_mgmt.private_ip_list
}

output "mgmt02_interface_ip" {
  value = aws_network_interface.asa02_mgmt.private_ip_list
}

output "inside01_interface_ip" {
  value = aws_network_interface.asa01_inside.private_ip_list
}

output "inside02_interface_ip" {
  value = aws_network_interface.asa02_inside.private_ip_list
}

output "outside01_interface_ip" {
  value = aws_network_interface.asa01_outside.private_ip_list
}

output "outside02_interface_ip" {
  value = aws_network_interface.asa02_outside.private_ip_list
}

output "dmz01_interface_ip" {
  value = aws_network_interface.asa01_dmz.private_ip_list
}

output "dmz02_interface_ip" {
  value = aws_network_interface.asa02_dmz.private_ip_list
}