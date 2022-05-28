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
  count             = var.mgmt_subnet_cidr != null ? length(var.mgmt_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.mgmt_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name = "${var.mgmt_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "outside_subnet" {
  count             = var.outside_subnet_cidr != null ? length(var.outside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.outside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.outside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "inside_subnet" {
  count             = var.inside_subnet_cidr != null ? length(var.inside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.inside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.inside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "diag_subnet" {
  count             = var.diag_subnet_cidr != null ? length(var.diag_subnet_cidr) : 0
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

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = local.con


  dynamic "ingress" {
    for_each = var.security_group_ingress_with_cidr
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      description = lookup(ingress.value, "description", null)
    }
  }


  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
      description = lookup(egress.value, "description", null)
    }
  }

  tags = merge({
    Name = "Public Allow"
  }, var.tags)
}

resource "aws_default_security_group" "default" {
  vpc_id = local.con

  dynamic "ingress" {
    for_each = var.security_group_ingress_with_cidr
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = [ "0.0.0.0/0", ]
      description = lookup(ingress.value, "description", null)
    }
  }


  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      cidr_blocks = [ "0.0.0.0/0", ]
      description = lookup(egress.value, "description", null)
    }
  }

  tags = merge({
    Name = "Local Allow"
  }, var.tags)
}
resource "aws_security_group" "testSG" {
  name        = "KDD"
  description      = "testingKDtesting"
  vpc_id      = local.con
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

# # ##################################################################################################################################
# # # Network Interfaces, FTD instance, Attaching the SG to interfaces
# # ##################################################################################################################################
resource "aws_network_interface" "ftd_mgmt" {
  #count = length(var.mgmt_subnet_cidr) != 0 ? length(var.mgmt_subnet_cidr) : 0 || length(var.mgmt_subnet_name) != 0 ? length(var.mgmt_subnet_name) : 0
  count             = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_mgmt_ip)
  description       = "asa${count.index}-mgmt"
  #subnet_id         = var.mgmt_subnet_cidr != [] ? aws_subnet.mgmt_subnet[count.index].id : data.aws_subnet.mgmt[count.index].id
  subnet_id         = local.mgmt_subnet[local.azs[count.index] - 1].id #element(local.mgmt_subnet[*])
  source_dest_check = false
  private_ips       = [var.ftd_mgmt_ip[count.index]]
}

resource "aws_network_interface" "ftd_outside" {
  #count = length(var.outside_subnet_cidr) != 0 ? length(var.outside_subnet_cidr) : 0 ||  length(var.outside_subnet_name) != 0 ? length(var.outside_subnet_name) : 0
  count             = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.ftd_outside_ip)
  description       = "asa${count.index}-outside"
  subnet_id         = local.outside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_outside_ip[count.index]]
}

resource "aws_network_interface" "ftd_inside" {
  #count = length(var.inside_subnet_cidr) != 0 ? length(var.inside_subnet_cidr) : 0 ||  length(var.inside_subnet_name) != 0 ? length(var.inside_subnet_name) : 0
  count             = length(var.inside_interface) != 0 ? length(var.inside_interface) : length(var.ftd_inside_ip)
  description       = "asa${count.index}-inside"
  subnet_id         = local.inside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_inside_ip[count.index]]
}

resource "aws_network_interface" "ftd_diag" {
  #count = length(var.dmz_subnet_cidr) != 0 ? length(var.dmz_subnet_cidr) : 0  ||  length(var.dmz_subnet_name) != 0 ? length(var.dmz_subnet_name) : 0
  count             = length(var.diag_interface) != 0 ? length(var.diag_interface) : length(var.ftd_diag_ip)
  description       = "asa{count.index}-diag"
  subnet_id         = local.diag_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_diag_ip[count.index]]
}

resource "aws_network_interface" "fmcmgmt" {
  count             = length(var.fmc_interface) != 0 ? 0 : 1
  description       = "Fmc_Management"
  subnet_id         = local.mgmt_subnet[local.azs[0] - 1].id
  source_dest_check = false
  private_ips       = [var.fmc_ip]
}

resource "aws_network_interface_sg_attachment" "ftd_mgmt_attachment" {
  count                = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_mgmt_ip)
  depends_on           = [aws_network_interface.ftd_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd_mgmt[count.index].id
}

resource "aws_network_interface_sg_attachment" "ftd_outside_attachment" {
  count                = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.ftd_outside_ip)
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd_outside[count.index].id
}

resource "aws_network_interface_sg_attachment" "ftd_inside_attachment" {
  count                = length(var.inside_interface) != 0 ? length(var.inside_interface) : length(var.ftd_inside_ip)
  depends_on           = [aws_network_interface.ftd_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd_inside[count.index].id
}

resource "aws_network_interface_sg_attachment" "ftd_diag_attachment" {
  count                = length(var.diag_interface) != 0 ? length(var.diag_interface) : length(var.ftd_diag_ip)
  depends_on           = [aws_network_interface.ftd_diag]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd_diag[count.index].id
}

resource "aws_network_interface_sg_attachment" "fmc_attachment" {
  depends_on           = [aws_network_interface.fmcmgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.fmcmgmt[0].id
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
# //create the route table for outside, inside and DMZ
resource "aws_route_table" "ftd_outside_route" {
  vpc_id = local.con
  tags = merge({
    Name = "outside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_inside_route" {
  vpc_id = local.con
  tags = merge({
    Name = "inside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "ftd_diag_route" {
  vpc_id = local.con
  tags = merge({
    Name = "diag network Routing table"
  }, var.tags)
}

#think how to make routes based on user inputs
# # //To define the default routes thru IGW

resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.ftd_outside_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.create_igw ? aws_internet_gateway.int_gw[0].id : data.aws_internet_gateway.default[0].internet_gateway_id
}

# # //To define the default route for inside network thur FTDv inside interface 
# # #resource "aws_route" "inside_default_route" {
# # #  route_table_id          = aws_route_table.ftd_inside_route.id
# # #  destination_cidr_block  = "0.0.0.0/0"
# # #  network_interface_id    = aws_network_interface.asa01_inside.id
# # #}

# # //To define the default route for DMZ network thur ASA DMZ interface 
# # #resource "aws_route" "DMZ_default_route" {
# # #  route_table_id          = aws_route_table.asa_dmz_route.id
# # #  destination_cidr_block  = "0.0.0.0/0"
# # #  network_interface_id    = aws_network_interface.asa01_dmz.id
# # #}

resource "aws_route_table_association" "outside_association" {
  count          = var.outside_subnet_cidr != null ? length(var.outside_subnet_cidr) : length(var.outside_subnet_name)
  subnet_id      = var.outside_subnet_cidr != null ? aws_subnet.outside_subnet[count.index].id : data.aws_subnet.outsideftd[count.index].id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.mgmt_subnet_cidr != null ? length(var.mgmt_subnet_cidr) : length(var.mgmt_subnet_name)
  subnet_id      = var.mgmt_subnet_cidr != null ? aws_subnet.mgmt_subnet[count.index].id : data.aws_subnet.mgmt[count.index].id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "inside_association" {
  count          = var.inside_subnet_cidr != null ? length(var.inside_subnet_cidr) : length(var.inside_subnet_name)
  subnet_id      = var.inside_subnet_cidr != null ? aws_subnet.inside_subnet[count.index].id : data.aws_subnet.insideftd[count.index].id
  route_table_id = aws_route_table.ftd_inside_route.id
}

resource "aws_route_table_association" "diag_association" {
  count          = var.diag_subnet_cidr != null ? length(var.diag_subnet_cidr) : length(var.diag_subnet_name)
  subnet_id      = var.diag_subnet_cidr != null ? aws_subnet.diag_subnet[count.index].id : data.aws_subnet.diagftd[count.index].id
  route_table_id = aws_route_table.ftd_diag_route.id
}

# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt and outside interface. 
# # ##################################################################################################################################
# # //External ip address creation 

resource "aws_eip" "ftd_mgmt-EIP" {
  count = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_mgmt_ip)
  vpc   = true
  tags = merge({
    "Name" = "ftd-${count.index} Management IP"
  }, var.tags)
}

# resource "aws_eip" "ftd_outside-EIP" {
#   count = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
#   vpc   = true
#   tags = merge({
#     "Name" = "ftd-${count.index} outside IP"
#   }, var.tags)
# }

resource "aws_eip_association" "ftd-mgmt-ip-assocation" {
  count                = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.ftd_outside_ip)
  network_interface_id = length(var.mgmt_interface) != 0 ? var.mgmt_interface[count.index] : aws_network_interface.ftd_mgmt[count.index].id
  allocation_id        = aws_eip.ftd_mgmt-EIP[count.index].id
}

# resource "aws_eip_association" "ftd-outside-ip-association" {
#   count                = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
#   network_interface_id = length(var.outside_interface) != 0 ? var.outside_interface[count.index] : aws_network_interface.ftd_outside[count.index].id
#   allocation_id        = aws_eip.ftd_outside-EIP[count.index].id
# }

resource "aws_eip" "fmcmgmt-EIP" {
  vpc   = true
  tags = {
    "Name" = "FMCv Management IP"
  }
}
resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.fmcmgmt[0].id
  allocation_id        = aws_eip.fmcmgmt-EIP.id
}
