# =====================================================
# Outputs
# =====================================================

# VPC Information
output "security_vpc_id" {
  description = "ID of the Security VPC"
  value       = aws_vpc.security_vpc.id
}

output "spoke1_vpc_id" {
  description = "ID of the Spoke-1 VPC"
  value       = aws_vpc.spoke1_vpc.id
}

output "spoke2_vpc_id" {
  description = "ID of the Spoke-2 VPC"
  value       = aws_vpc.spoke2_vpc.id
}

# Transit Gateway Information
output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main_tgw.id
}

# SSH Key Information
output "ssh_private_key_file" {
  description = "Location of the generated SSH private key file"
  value       = local_file.private_key.filename
}

output "ssh_key_name" {
  description = "Name of the AWS Key Pair"
  value       = aws_key_pair.deployer.key_name
}

# Shared Subnet Information
output "management_subnet_id" {
  description = "ID of the shared Management subnet"
  value       = aws_subnet.management.id
}

output "diagnostic_subnet_id" {
  description = "ID of the shared Diagnostic subnet"
  value       = aws_subnet.diagnostic.id
}

output "outside_subnet_id" {
  description = "ID of the shared Outside subnet"
  value       = aws_subnet.outside.id
}

output "inside_subnet_id" {
  description = "ID of the shared Inside subnet"
  value       = aws_subnet.inside.id
}

output "tgw_subnet_id" {
  description = "ID of the Transit Gateway subnet"
  value       = aws_subnet.tgw.id
}

# Route Table Information
output "management_route_table_id" {
  description = "ID of the Management route table"
  value       = aws_route_table.management_rt.id
}

output "outside_route_table_id" {
  description = "ID of the Outside route table"
  value       = aws_route_table.outside_rt.id
}

output "private_route_table_id" {
  description = "ID of the Private route table"
  value       = aws_route_table.security_private_rt.id
}

# FTDv Instance Information
output "egress_ftdv_id" {
  description = "Instance ID of Egress FTDv"
  value       = aws_instance.egress_ftdv.id
}

output "ingress_ftdv_id" {
  description = "Instance ID of Ingress FTDv"
  value       = aws_instance.ingress_ftdv.id
}

output "eastwest_ftdv_id" {
  description = "Instance ID of EastWest FTDv"
  value       = aws_instance.eastwest_ftdv.id
}

# FTDv Management Public IPs
output "egress_ftdv_mgmt_public_ip" {
  description = "Management Public IP of Egress FTDv"
  value       = aws_eip.egress_mgmt_eip.public_ip
}

output "ingress_ftdv_mgmt_public_ip" {
  description = "Management Public IP of Ingress FTDv"
  value       = aws_eip.ingress_mgmt_eip.public_ip
}

output "eastwest_ftdv_mgmt_public_ip" {
  description = "Management Public IP of EastWest FTDv"
  value       = aws_eip.eastwest_mgmt_eip.public_ip
}

# FTDv Outside Public IPs
output "egress_ftdv_outside_public_ip" {
  description = "Outside Public IP of Egress FTDv"
  value       = aws_eip.egress_outside_eip.public_ip
}

output "ingress_ftdv_outside_public_ip" {
  description = "Outside Public IP of Ingress FTDv"
  value       = aws_eip.ingress_outside_eip.public_ip
}

output "eastwest_ftdv_outside_public_ip" {
  description = "Outside Public IP of EastWest FTDv"
  value       = aws_eip.eastwest_outside_eip.public_ip
}

# FTDv Private IPs
output "egress_ftdv_mgmt_private_ip" {
  description = "Management Private IP of Egress FTDv"
  value       = aws_network_interface.egress_mgmt.private_ip
}

output "egress_ftdv_inside_private_ip" {
  description = "Inside Private IP of Egress FTDv"
  value       = aws_network_interface.egress_inside.private_ip
}

output "ingress_ftdv_mgmt_private_ip" {
  description = "Management Private IP of Ingress FTDv"
  value       = aws_network_interface.ingress_mgmt.private_ip
}

output "ingress_ftdv_inside_private_ip" {
  description = "Inside Private IP of Ingress FTDv"
  value       = aws_network_interface.ingress_inside.private_ip
}

output "eastwest_ftdv_mgmt_private_ip" {
  description = "Management Private IP of EastWest FTDv"
  value       = aws_network_interface.eastwest_mgmt.private_ip
}

output "eastwest_ftdv_inside_private_ip" {
  description = "Inside Private IP of EastWest FTDv"
  value       = aws_network_interface.eastwest_inside.private_ip
}

# Ubuntu Instance Information
output "ubuntu_spoke1_id" {
  description = "Instance ID of Ubuntu in Spoke-1"
  value       = aws_instance.ubuntu_spoke1.id
}

output "ubuntu_spoke2_id" {
  description = "Instance ID of Ubuntu in Spoke-2"
  value       = aws_instance.ubuntu_spoke2.id
}

output "ubuntu_spoke1_private_ip" {
  description = "Private IP of Ubuntu in Spoke-1"
  value       = aws_instance.ubuntu_spoke1.private_ip
}

output "ubuntu_spoke2_private_ip" {
  description = "Private IP of Ubuntu in Spoke-2"
  value       = aws_instance.ubuntu_spoke2.private_ip
}

# Connection Information
output "ftdv_connection_info" {
  description = "Connection information for FTDv instances"
  value = {
    egress_ftdv = {
      management_url = "https://${aws_eip.egress_mgmt_eip.public_ip}"
      ssh_command    = "ssh admin@${aws_eip.egress_mgmt_eip.public_ip}"
    }
    ingress_ftdv = {
      management_url = "https://${aws_eip.ingress_mgmt_eip.public_ip}"
      ssh_command    = "ssh admin@${aws_eip.ingress_mgmt_eip.public_ip}"
    }
    eastwest_ftdv = {
      management_url = "https://${aws_eip.eastwest_mgmt_eip.public_ip}"
      ssh_command    = "ssh admin@${aws_eip.eastwest_mgmt_eip.public_ip}"
    }
  }
}

# Summary Information
output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    prefix              = var.prefix
    region              = var.aws_region
    security_vpc_cidr   = var.security_vpc_cidr
    spoke1_vpc_cidr     = var.spoke1_vpc_cidr
    spoke2_vpc_cidr     = var.spoke2_vpc_cidr
    ftdv_instance_type  = var.ftdv_instance_type
    ubuntu_instance_type = var.ubuntu_instance_type
    firewalls_deployed  = 3
    spokes_deployed     = 2
    shared_subnets = {
      management = var.management_subnet_cidr
      diagnostic = var.diagnostic_subnet_cidr
      outside    = var.outside_subnet_cidr
      inside     = var.inside_subnet_cidr
    }
  }
}

# FTDv IP Address Assignment Summary
output "ftdv_ip_assignments" {
  description = "Private IP address assignments for each FTDv instance"
  value = {
    egress_ftdv = {
      management = "10.0.0.10"
      diagnostic = "10.0.1.10"
      outside    = "10.0.2.10"
      inside     = "10.0.3.10"
    }
    ingress_ftdv = {
      management = "10.0.0.20"
      diagnostic = "10.0.1.20"
      outside    = "10.0.2.20"
      inside     = "10.0.3.20"
    }
    eastwest_ftdv = {
      management = "10.0.0.30"
      diagnostic = "10.0.1.30"
      outside    = "10.0.2.30"
      inside     = "10.0.3.30"
    }
  }
}