resource "aws_vpc" "asa_vpc" {
  count                = var.vpc_cidr != "" ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = merge({
    Name = var.vpc_name
  }, var.tags)
}

resource "aws_subnet" "mgmt_subnet" {
  count             = var.mgmt_subnet_cidr != [] ? length(var.mgmt_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.mgmt_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name = "${var.mgmt_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "outside_subnet" {
  count             = var.outside_subnet_cidr != [] ? length(var.outside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.outside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.outside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "inside_subnet" {
  count             = var.inside_subnet_cidr != [] ? length(var.inside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.inside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.inside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "diag_subnet" {
  count             = var.diag_subnet_cidr != [] ? length(var.diag_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.diag_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.diag_subnet_name[count.index]
  }, var.tags)
}

# # #################################################################################################################################
# # # Security Group
# # #################################################################################################################################

resource "aws_security_group" "outside_sg" {
  name        = "Outside Interface SG"
  vpc_id      = local.con

  dynamic "ingress" {
    for_each = var.outside_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inside_sg" {
  name        = "Inside Interface SG"
  vpc_id      = local.con

  dynamic "ingress" {
    for_each = var.inside_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mgmt_sg" {
  name        = "FTD Management Interface SG"
  vpc_id      = local.con

  dynamic "ingress" {
    for_each = var.mgmt_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fmc_mgmt_sg" {
  name        = "FMC Management Interface SG"
  vpc_id      = local.con

  dynamic "ingress" {
    for_each = var.fmc_mgmt_interface_sg
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "no_access" {
  name        = "No Access"
  vpc_id      = local.con
}

# # ##################################################################################################################################
# # # Network Interfaces
# # ##################################################################################################################################
resource "aws_network_interface" "ftd_mgmt" {
  count             = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_mgmt_ip)
  description       = "asa${count.index}-mgmt"
  subnet_id         = local.mgmt_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_mgmt_ip[count.index]]
  security_groups   = [aws_security_group.mgmt_sg.id]
}

resource "aws_network_interface" "ftd_outside" {
  count             = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.ftd_outside_ip)
  description       = "asa${count.index}-outside"
  subnet_id         = local.outside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_outside_ip[count.index]]
  security_groups   = [aws_security_group.outside_sg.id]
}

resource "aws_network_interface" "ftd_inside" {
  count             = length(var.inside_interface) != 0 ? length(var.inside_interface) : length(var.ftd_inside_ip)
  description       = "asa${count.index}-inside"
  subnet_id         = local.inside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_inside_ip[count.index]]
  security_groups   = [aws_security_group.inside_sg.id]
}

resource "aws_network_interface" "ftd_diag" {
  count             = length(var.diag_interface) != 0 ? length(var.diag_interface) : length(var.ftd_diag_ip)
  description       = "asa{count.index}-diag"
  subnet_id         = local.diag_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_diag_ip[count.index]]
  security_groups   = [aws_security_group.no_access.id]
}

resource "aws_network_interface" "fmcmgmt" {
  count             = length(var.fmc_interface) != 0 ? 0 : 1
  description       = "Fmc_Management"
  subnet_id         = local.mgmt_subnet[local.azs[0] - 1].id
  source_dest_check = false
  private_ips       = [var.fmc_ip]
  security_groups   = [aws_security_group.fmc_mgmt_sg.id]
}

# # ##################################################################################################################################
# # #Internet Gateway and Routing Tables
# # ##################################################################################################################################

# //define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = local.con
  tags = merge({
    Name = "Internet Gateway"
  }, var.tags)
}

resource "aws_route_table" "ftd_mgmt_route" {
  count  = var.mgmt_subnet_cidr != [] ? length(var.mgmt_subnet_cidr) : length(var.mgmt_subnet_name)
  vpc_id = local.con
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw[0].id
  }

  tags = merge({
    Name = "Management network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_outside_route" {
  count  = var.outside_subnet_cidr != [] ? length(var.outside_subnet_cidr) : length(var.outside_subnet_name)
  vpc_id = local.con
  tags = merge({
    Name = "outside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_inside_route" {
  count  = var.inside_subnet_cidr != [] ? length(var.inside_subnet_cidr) : length(var.inside_subnet_name)
  vpc_id = local.con
  tags = merge({
    Name = "inside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_diag_route" {
  count  = var.diag_subnet_cidr != [] ? length(var.diag_subnet_cidr) : length(var.diag_subnet_name)
  vpc_id = local.con
  tags = merge({
    Name = "diag network Routing table"
  }, var.tags)
}

resource "aws_route_table_association" "outside_association" {
  count          = var.outside_subnet_cidr != [] ? length(var.outside_subnet_cidr) : length(var.outside_subnet_name)
  subnet_id      = var.outside_subnet_cidr != [] ? aws_subnet.outside_subnet[count.index].id : data.aws_subnet.outsideftd[count.index].id
  route_table_id = aws_route_table.ftd_outside_route[count.index].id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.mgmt_subnet_cidr != [] ? length(var.mgmt_subnet_cidr) : length(var.mgmt_subnet_name)
  subnet_id      = var.mgmt_subnet_cidr != [] ? aws_subnet.mgmt_subnet[count.index].id : data.aws_subnet.mgmt[count.index].id
  route_table_id = aws_route_table.ftd_mgmt_route[count.index].id
}

resource "aws_route_table_association" "inside_association" {
  count          = var.inside_subnet_cidr != [] ? length(var.inside_subnet_cidr) : length(var.inside_subnet_name)
  subnet_id      = var.inside_subnet_cidr != [] ? aws_subnet.inside_subnet[count.index].id : data.aws_subnet.insideftd[count.index].id
  route_table_id = aws_route_table.ftd_inside_route[count.index].id
}

resource "aws_route_table_association" "diag_association" {
  count          = var.diag_subnet_cidr != [] ? length(var.diag_subnet_cidr) : length(var.diag_subnet_name)
  subnet_id      = var.diag_subnet_cidr != [] ? aws_subnet.diag_subnet[count.index].id : data.aws_subnet.diagftd[count.index].id
  route_table_id = aws_route_table.ftd_diag_route[count.index].id
}

# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt interface. 
# # ##################################################################################################################################

resource "aws_eip" "ftd_mgmt-EIP" {
  count = var.use_ftd_eip ? (length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_mgmt_ip)) : 0
  vpc   = true
  tags = merge({
    "Name" = "ftd-${count.index} Management IP"
  }, var.tags)
}

resource "aws_eip_association" "ftd-mgmt-ip-assocation" {
  count                = length(aws_eip.ftd_mgmt-EIP)
  network_interface_id = length(var.mgmt_interface) != 0 ? var.mgmt_interface[count.index] : aws_network_interface.ftd_mgmt[count.index].id
  allocation_id        = aws_eip.ftd_mgmt-EIP[count.index].id
}

resource "aws_eip" "fmcmgmt-EIP" {
  count = var.use_fmc_eip ? 1 : 0
  vpc   = true
  tags = {
    "Name" = "FMCv Management IP"
  }
}
resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  count                = var.use_fmc_eip ? 1 : 0
  network_interface_id = aws_network_interface.fmcmgmt[0].id
  allocation_id        = aws_eip.fmcmgmt-EIP[0].id
}