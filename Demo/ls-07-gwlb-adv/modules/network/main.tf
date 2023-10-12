# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_vpc" "ftd_vpc" {
  count                = var.vpc_cidr != "" ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  #enable_classiclink   = false
  instance_tenancy     = "default"
  tags = merge({
    Name = "${var.pod_prefix}-${var.vpc_name}"
  }, var.tags)
}

resource "aws_subnet" "mgmt_subnet" {
  count                   = length(var.mgmt_subnet_cidr) != 0 ? length(var.mgmt_subnet_cidr) : 0
  vpc_id                  = local.con
  cidr_block              = var.mgmt_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.pod_prefix}-${var.mgmt_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "outside_subnet" {
  count             = length(var.outside_subnet_cidr) != 0 ? length(var.outside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.outside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${var.pod_prefix}-${var.outside_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "inside_subnet" {
  count             = length(var.inside_subnet_cidr) != 0 ? length(var.inside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.inside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${var.pod_prefix}-${var.inside_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "diag_subnet" {
  count             = length(var.diag_subnet_cidr) != 0 ? length(var.diag_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.diag_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${var.pod_prefix}-${var.diag_subnet_name[count.index]}"
  }, var.tags)
}

# # #################################################################################################################################
# # # Security Group
# # #################################################################################################################################

resource "aws_security_group" "outside_sg" {
  name        = "Outside InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall OutsideSG"
}

# tfsec:ignore:aws-vpc-add-description-to-security-group-rule
# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "outside_sg_ingress" {
  count       = length(var.outside_interface_sg)
  type        = "ingress"
  from_port   = lookup(var.outside_interface_sg[count.index], "from_port", null)
  to_port     = lookup(var.outside_interface_sg[count.index], "to_port", null)
  protocol    = lookup(var.outside_interface_sg[count.index], "protocol", null)
  cidr_blocks = lookup(var.outside_interface_sg[count.index], "cidr_blocks", null)
  #description = var.outside_interface_sg[count.index].description
  security_group_id = aws_security_group.outside_sg.id
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "outside_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall OutsideSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.outside_sg.id
}

resource "aws_security_group" "inside_sg" {
  name        = "${var.pod_prefix}-Inside InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall InsideSG"
}

# tfsec:ignore:aws-vpc-add-description-to-security-group-rule
# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "inside_sg_ingress" {
  count       = length(var.inside_interface_sg)
  type        = "ingress"
  from_port   = lookup(var.inside_interface_sg[count.index], "from_port", null)
  to_port     = lookup(var.inside_interface_sg[count.index], "to_port", null)
  protocol    = lookup(var.inside_interface_sg[count.index], "protocol", null)
  cidr_blocks = lookup(var.inside_interface_sg[count.index], "cidr_blocks", null)
  #description = var.outside_interface_sg[count.index].description
  security_group_id = aws_security_group.inside_sg.id
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "inside_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall InsideSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.inside_sg.id
}

resource "aws_security_group" "mgmt_sg" {
  name        = "${var.pod_prefix}-FTD Management InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall MGMTSG"
}

# tfsec:ignore:aws-vpc-add-description-to-security-group-rule
# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "mgmt_sg_ingress" {
  count       = length(var.mgmt_interface_sg)
  type        = "ingress"
  from_port   = lookup(var.mgmt_interface_sg[count.index], "from_port", null)
  to_port     = lookup(var.mgmt_interface_sg[count.index], "to_port", null)
  protocol    = lookup(var.mgmt_interface_sg[count.index], "protocol", null)
  cidr_blocks = lookup(var.mgmt_interface_sg[count.index], "cidr_blocks", null)
  #description = var.outside_interface_sg[count.index].description
  security_group_id = aws_security_group.mgmt_sg.id
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "mgmt_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall MGMTSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group" "fmc_mgmt_sg" {
  count       = var.create_fmc ? 1 : 0
  name        = "${var.pod_prefix}-FMC Management InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall FMC MGMTSG"
}

# tfsec:ignore:aws-vpc-add-description-to-security-group-rule
# tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "fmc_mgmt_sg_ingress" {
  count       = var.create_fmc ? length(var.fmc_mgmt_interface_sg) : 0
  type        = "ingress"
  from_port   = lookup(var.fmc_mgmt_interface_sg[count.index], "from_port", null)
  to_port     = lookup(var.fmc_mgmt_interface_sg[count.index], "to_port", null)
  protocol    = lookup(var.fmc_mgmt_interface_sg[count.index], "protocol", null)
  cidr_blocks = lookup(var.fmc_mgmt_interface_sg[count.index], "cidr_blocks", null)
  #description = var.outside_interface_sg[count.index].description
  security_group_id = aws_security_group.fmc_mgmt_sg[0].id
}

# tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "fmc_mgmt_sg_egress" {
  count             = var.create_fmc ? 1 : 0
  type              = "egress"
  description       = "Secure Firewall FMC MGMTSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fmc_mgmt_sg[0].id
}

resource "aws_security_group" "no_access" {
  name        = "${var.pod_prefix}-No Access"
  vpc_id      = local.con
  description = "No AccessSG"
}

# # ##################################################################################################################################
# # # Network Interfaces
# # ##################################################################################################################################

# when ip assigned using DHCP
resource "aws_network_interface" "ftd_mgmt" {
  count             = length(var.mgmt_subnet_cidr) != 0 ? length(var.mgmt_subnet_cidr) : (length(var.mgmt_subnet_name) != 0 ? length(var.mgmt_subnet_name) : 0)
  description       = "ftd${count.index}-mgmt"
  subnet_id         = local.mgmt_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  #private_ips       = [var.ftd_mgmt_ip[count.index]]
  security_groups   = [aws_security_group.mgmt_sg.id]
}

# IP address statically assigned
# resource "aws_network_interface" "ftd_mgmt" {
#   count             = length(var.mgmt_interface) == 0 ? length(var.ftd_mgmt_ip) : 0
#   description       = "ftd${count.index}-mgmt"
#   subnet_id         = local.mgmt_subnet[local.azs[count.index] - 1].id
#   source_dest_check = false
#   private_ips       = [var.ftd_mgmt_ip[count.index]]
#   security_groups   = [aws_security_group.mgmt_sg.id]
# }

# when ip assigned using DHCP
resource "aws_network_interface" "ftd_outside" {
  count             = length(var.outside_subnet_cidr) != 0 ? length(var.outside_subnet_cidr) : (length(var.outside_subnet_name) != 0 ? length(var.outside_subnet_name) : 0)
  description       = "ftd${count.index}-outside"
  subnet_id         = local.outside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  #private_ips       = [var.ftd_outside_ip[count.index]]
  security_groups   = [aws_security_group.outside_sg.id]
}

# IP address statically assigned
# resource "aws_network_interface" "ftd_outside" {
#   count             = length(var.outside_interface) == 0 ? length(var.ftd_outside_ip) : 0
#   description       = "ftd${count.index}-outside"
#   subnet_id         = local.outside_subnet[local.azs[count.index] - 1].id
#   source_dest_check = false
#   private_ips       = [var.ftd_outside_ip[count.index]]
#   security_groups   = [aws_security_group.outside_sg.id]
# }

# when ip assigned using DHCP
resource "aws_network_interface" "ftd_inside" {
  count             = length(var.inside_subnet_cidr) != 0 ? length(var.inside_subnet_cidr) : (length(var.inside_subnet_name) != 0 ? length(var.inside_subnet_name) : 0)
  description       = "ftd${count.index}-inside"
  subnet_id         = local.inside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  #private_ips       = [var.ftd_inside_ip[count.index]]
  security_groups   = [aws_security_group.inside_sg.id]
}

# IP address statically assigned
# resource "aws_network_interface" "ftd_inside" {
#   count             = length(var.inside_interface) == 0 ? length(var.ftd_inside_ip) : 0
#   description       = "ftd${count.index}-inside"
#   subnet_id         = local.inside_subnet[local.azs[count.index] - 1].id
#   source_dest_check = false
#   #private_ips       = [var.ftd_inside_ip[count.index]]
#   security_groups   = [aws_security_group.inside_sg.id]
# }

resource "aws_network_interface" "ftd_diag" {
  count             = length(var.diag_subnet_cidr) != 0 ? length(var.diag_subnet_cidr) : (length(var.diag_subnet_name) != 0 ? length(var.diag_subnet_name) : 0)
  description       = "ftd${count.index}-diag"
  subnet_id         = local.diag_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  #private_ips       = [var.ftd_diag_ip[count.index]]
  security_groups   = [aws_security_group.no_access.id]
}

# #DHCP
# resource "aws_network_interface" "fmcmgmt" {
#   count             = var.create_fmc ? (length(var.fmc_interface) != 0 ? 0 : var.fmc_ip == "" ? 0 : 1) : 0
#   description       = "Fmc_Management"
#   subnet_id         = local.mgmt_subnet[local.azs[0] - 1].id
#   source_dest_check = false
#   #private_ips       = [var.fmc_ip]
#   security_groups   = [aws_security_group.fmc_mgmt_sg[0].id]
# }

# Static FMC IP
resource "aws_network_interface" "fmcmgmt" {
  count             = var.create_fmc ? (length(var.fmc_interface) != 0 ? 0 : 1) : 0
  description       = "Fmc_Management"
  subnet_id         = local.mgmt_subnet[local.azs[0] - 1].id
  source_dest_check = false
  private_ips       = [var.fmc_ip]
  security_groups   = [aws_security_group.fmc_mgmt_sg[0].id]
}

# # ##################################################################################################################################
# # #Internet Gateway and Routing Tables
# # ##################################################################################################################################

# //define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = local.con
  tags = merge({
    Name = "${var.pod_prefix}-Internet Gateway"
  }, var.tags)
}

#mgmt subnet is getting created so create_igw condition should not be there
resource "aws_route_table" "ftd_mgmt_route" {
  count  = length(local.mgmt_subnet)
  vpc_id = local.con
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =  var.nat_gw[count.index] #local.igw # modeule.nat_gw.ngw
  }

  tags = merge({
    Name = "${var.pod_prefix}-Management network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_outside_route" {
  count  = length(local.outside_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "${var.pod_prefix}-outside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_inside_route" {
  count  = length(local.inside_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "${var.pod_prefix}-inside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_diag_route" {
  count  = length(local.diag_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "${var.pod_prefix}-diag network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "outside_association" {
  count          = var.rta ? length(local.outside_subnet) : 0
  subnet_id      = local.outside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_outside_route[count.index].id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.create_igw ? length(local.mgmt_subnet) : 0
  subnet_id      = local.mgmt_subnet[count.index].id
  route_table_id = aws_route_table.ftd_mgmt_route[count.index].id
}

resource "aws_route_table_association" "inside_association" {
  count          = length(local.inside_subnet)
  subnet_id      = local.inside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_inside_route[count.index].id
}

resource "aws_route_table_association" "diag_association" {
  count          = length(local.diag_subnet)
  subnet_id      = local.diag_subnet[count.index].id
  route_table_id = aws_route_table.ftd_diag_route[count.index].id
}

# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt interface. 
# # ##################################################################################################################################

resource "aws_eip" "ftd_mgmt_eip" {
  count = var.use_ftd_eip ? length(var.mgmt_subnet_name) : 0
  tags = merge({
    "Name" = "${var.pod_prefix}-ftd-${count.index} Management IP"
  }, var.tags)
}

resource "aws_eip_association" "ftd_mgmt_ip_assocation" {
  count                = length(aws_eip.ftd_mgmt_eip)
  network_interface_id = aws_network_interface.ftd_mgmt[count.index].id
  allocation_id        = aws_eip.ftd_mgmt_eip[count.index].id
}

resource "aws_eip" "fmcmgmt_eip" {
  count = var.use_fmc_eip ? 1 : 0
  tags = {
    "Name" = "${var.pod_prefix}-FMCv Management IP"
  }
}

resource "aws_eip_association" "fmc_mgmt_ip_assocation" {
  count                = var.use_fmc_eip ? 1 : 0
  network_interface_id = aws_network_interface.fmcmgmt[0].id
  allocation_id        = aws_eip.fmcmgmt_eip[0].id
}