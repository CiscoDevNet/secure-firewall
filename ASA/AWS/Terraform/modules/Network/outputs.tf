output "vpc_id" {
  value = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
}

output "mgmt_interface" {
  value = aws_network_interface.asa_mgmt.*.id
}

output "outside_interface" {
  value = aws_network_interface.asa_outside.*.id
}


output "inside_interface" {
  value = aws_network_interface.asa_inside.*.id
}


output "dmz_interface" {
  value = aws_network_interface.asa_dmz.*.id
}


output "mgmt_subnet" {
  value = var.mgmt_subnet_cidr != null ? aws_subnet.mgmt_subnet.*.id : data.aws_subnet.mgmt.*.id
}

output "inside_subnet" {
  value = var.inside_subnet_cidr != null ? aws_subnet.inside_subnet.*.id : data.aws_subnet.insideasa.*.id
}

output "outside_subnet" {
  value = var.outside_subnet_cidr != null ? aws_subnet.outside_subnet.*.id : data.aws_subnet.outsideasa.*.id
}


output "mgmt_interface_ip" {
  value = aws_network_interface.asa_mgmt.*.private_ip_list
}


output "inside_interface_ip" {
  value = aws_network_interface.asa_inside.*.private_ip_list
}


output "outside_interface_ip" {
  value = aws_network_interface.asa_outside.*.private_ip_list
}

output "dmz_interface_ip" {
  value = aws_network_interface.asa_dmz.*.private_ip_list
}
