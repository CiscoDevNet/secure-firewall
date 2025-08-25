
# Users can enable VPC flow logs in their VPC as per their environment with the approprite destination for the logs
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "ftd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.prefix}-${var.vpc_name}"
  }
}

resource "aws_subnet" "mgmt_subnet" {
  count                   = length(local.mgmt_subnet)
  vpc_id                  = aws_vpc.ftd_vpc.id
  cidr_block              = local.mgmt_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-${local.mgmt_subnet_name[count.index]}"
  }
}

resource "aws_subnet" "outside_subnet" {
  count             = length(local.outside_subnet)
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = local.outside_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${local.outside_subnet_name[count.index]}"
  }
}

resource "aws_subnet" "inside_subnet" {
  count             = length(local.inside_subnet)
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = local.inside_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${local.inside_subnet_name[count.index]}"
  }
}

resource "aws_subnet" "diag_subnet" {
  count             = length(local.diag_subnet)
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = local.diag_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${local.diag_subnet_name[count.index]}"
  }
}

# # #################################################################################################################################
# # # Security Group
# # #################################################################################################################################

resource "aws_security_group" "outside_sg" {
  name        = "${var.prefix}-${"Outside InterfaceSG"}"
  vpc_id      = aws_vpc.ftd_vpc.id
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
  name        = "${var.prefix}-${"Inside InterfaceSG"}"
  vpc_id      = aws_vpc.ftd_vpc.id
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
  name        = "${var.prefix}-${"FTD Management InterfaceSG"}"
  vpc_id      = aws_vpc.ftd_vpc.id
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


resource "aws_security_group" "no_access" {
  name        = "${var.prefix}-${"No Access"}"
  vpc_id      = aws_vpc.ftd_vpc.id
  description = "No AccessSG"
}

# # ##################################################################################################################################
# # # Network Interfaces
# # ##################################################################################################################################

# when ip assigned using DHCP
resource "aws_network_interface" "ftd_mgmt" {
  count             = length(local.mgmt_subnet)
  description       = "${var.prefix}-ftd${count.index}-mgmt"
  subnet_id         = aws_subnet.mgmt_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  security_groups   = [aws_security_group.mgmt_sg.id]
}
# when ip assigned using DHCP
resource "aws_network_interface" "ftd_outside" {
  count             = length(local.outside_subnet)
  description       = "${var.prefix}-ftd${count.index}-outside"
  subnet_id         = aws_subnet.outside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  security_groups   = [aws_security_group.outside_sg.id]
}

# when ip assigned using DHCP
resource "aws_network_interface" "ftd_inside" {
  count             = length(local.inside_subnet)
  description       = "${var.prefix}-ftd${count.index}-inside"
  subnet_id         = aws_subnet.inside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  security_groups   = [aws_security_group.inside_sg.id]
}
resource "aws_network_interface" "ftd_diag" {
  count             = length(local.diag_subnet)
  description       = "${var.prefix}-ftd${count.index}-diag"
  subnet_id         = aws_subnet.diag_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  security_groups   = [aws_security_group.no_access.id]
}

# # ##################################################################################################################################
# # #Internet Gateway and Routing Tables
# # ##################################################################################################################################

# //define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.ftd_vpc.id
  tags = {
    Name = "${var.prefix}-Internet Gateway"
  }
}

resource "aws_route_table" "ftd_mgmt_route" {
  count  = var.create_igw ? length(local.mgmt_subnet) : 0
  vpc_id = aws_vpc.ftd_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw.id
  }

  tags = {
    Name = "${var.prefix}-Management network Routing table"
  }
}

resource "aws_route_table" "ftd_outside_route" {
  count  = length(local.outside_subnet)
  vpc_id = aws_vpc.ftd_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw.id
  }

  tags = merge({
    Name = "${var.prefix}-outside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_inside_route" {
  count  = length(local.inside_subnet)
  vpc_id = aws_vpc.ftd_vpc.id
  tags = merge({
    Name = "${var.prefix}-inside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_diag_route" {
  count  = length(local.diag_subnet)
  vpc_id = aws_vpc.ftd_vpc.id
  tags = merge({
    Name = "${var.prefix}-diag network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "outside_association" {
  count          = var.rta ? length(local.outside_subnet) : 0
  subnet_id      = aws_subnet.outside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_outside_route[count.index].id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.create_igw ? length(local.mgmt_subnet) : 0
  subnet_id      = aws_subnet.mgmt_subnet[count.index].id
  route_table_id = aws_route_table.ftd_mgmt_route[count.index].id
}

resource "aws_route_table_association" "inside_association" {
  count          = length(local.inside_subnet)
  subnet_id      = aws_subnet.inside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_inside_route[count.index].id
}

resource "aws_route_table_association" "diag_association" {
  count          = length(local.diag_subnet)
  subnet_id      = aws_subnet.diag_subnet[count.index].id
  route_table_id = aws_route_table.ftd_diag_route[count.index].id
}

# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt interface. 
# # ##################################################################################################################################

resource "aws_eip" "ftd_mgmt_eip" {
  count = var.use_ftd_eip ? var.ftd_count : 0
  tags = merge({
    "Name" = "${var.prefix}-ftd-${count.index} Management IP"
  }, var.tags)
}

resource "aws_eip_association" "ftd_mgmt_ip_assocation" {
  count                = length(aws_eip.ftd_mgmt_eip)
  network_interface_id = aws_network_interface.ftd_mgmt[count.index].id
  allocation_id        = aws_eip.ftd_mgmt_eip[count.index].id
}

resource "aws_eip" "ftd_outside_eip" {
  count = var.ftd_count
  tags = merge({
    "Name" = "${var.prefix}-ftd-${count.index} Outside IP"
  }, var.tags)
}

resource "aws_eip_association" "ftd_outside_ip_assocation" {
  count                = length(aws_eip.ftd_outside_eip)
  network_interface_id = aws_network_interface.ftd_outside[count.index].id
  allocation_id        = aws_eip.ftd_outside_eip[count.index].id
}