resource "aws_vpc" "asa_vpc" {
  count                = var.vpc_cidr != null ? 1 : 0
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

resource "aws_subnet" "dmz_subnet" {
  count             = var.dmz_subnet_cidr != null ? length(var.dmz_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.dmz_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.dmz_subnet_name[count.index]
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
      cidr_blocks = [var.vpc_cidr != null ? aws_vpc.asa_vpc[0].cidr_block : data.aws_vpc.asa_vpc[0].cidr_block]
      description = lookup(ingress.value, "description", null)
    }
  }


  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      cidr_blocks = [var.vpc_cidr != null ? aws_vpc.asa_vpc[0].cidr_block : data.aws_vpc.asa_vpc[0].cidr_block]
      description = lookup(egress.value, "description", null)
    }
  }

  tags = merge({
    Name = "Local Allow"
  }, var.tags)
}



# # ##################################################################################################################################
# # # Network Interfaces, ASA instance, Attaching the SG to interfaces
# # ##################################################################################################################################
resource "aws_network_interface" "asa_mgmt" {
  #count = length(var.mgmt_subnet_cidr) != 0 ? length(var.mgmt_subnet_cidr) : 0 || length(var.mgmt_subnet_name) != 0 ? length(var.mgmt_subnet_name) : 0
  count             = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.mgmt_subnet_name)
  description       = "asa${count.index}-mgmt"
  subnet_id         = var.mgmt_subnet_cidr != [] ? aws_subnet.mgmt_subnet[count.index].id : data.aws_subnet.mgmt[count.index].id
  source_dest_check = false
  private_ips       = [var.asa_mgmt_ip[count.index]]
}

resource "aws_network_interface" "asa_outside" {
  #count = length(var.outside_subnet_cidr) != 0 ? length(var.outside_subnet_cidr) : 0 ||  length(var.outside_subnet_name) != 0 ? length(var.outside_subnet_name) : 0
  count             = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
  description       = "asa${count.index}-outside"
  subnet_id         = var.outside_subnet_cidr != [] ? aws_subnet.outside_subnet[count.index].id : data.aws_subnet.outsideasa[count.index].id
  source_dest_check = false
  private_ips       = [var.asa_outside_ip[count.index]]
}

resource "aws_network_interface" "asa_inside" {
  #count = length(var.inside_subnet_cidr) != 0 ? length(var.inside_subnet_cidr) : 0 ||  length(var.inside_subnet_name) != 0 ? length(var.inside_subnet_name) : 0
  count             = length(var.inside_interface) != 0 ? length(var.inside_interface) : length(var.inside_subnet_name)
  description       = "asa${count.index}-inside"
  subnet_id         = var.inside_subnet_cidr != [] ? aws_subnet.inside_subnet[count.index].id : data.aws_subnet.insideasa[count.index].id
  source_dest_check = false
  private_ips       = [var.asa_inside_ip[count.index]]
}

resource "aws_network_interface" "asa_dmz" {
  #count = length(var.dmz_subnet_cidr) != 0 ? length(var.dmz_subnet_cidr) : 0  ||  length(var.dmz_subnet_name) != 0 ? length(var.dmz_subnet_name) : 0
  count             = length(var.dmz_interface) != 0 ? length(var.dmz_interface) : length(var.dmz_subnet_name)
  description       = "asa{count.index}-dmz"
  subnet_id         = var.dmz_subnet_cidr != null ? aws_subnet.dmz_subnet[count.index].id : data.aws_subnet.asadmz[count.index].id
  source_dest_check = false
  private_ips       = [var.asa_dmz_ip[count.index]]

}

resource "aws_network_interface_sg_attachment" "asa_mgmt_attachment" {
  count                = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.mgmt_subnet_name)
  depends_on           = [aws_network_interface.asa_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa_mgmt[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_outside_attachment" {
  count                = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa_outside[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_inside_attachment" {
  count                = length(var.inside_interface) != 0 ? length(var.inside_interface) : length(var.inside_subnet_name)
  depends_on           = [aws_network_interface.asa_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa_inside[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_dmz_attachment" {
  count                = length(var.dmz_interface) != 0 ? length(var.dmz_interface) : length(var.dmz_subnet_name)
  depends_on           = [aws_network_interface.asa_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa_dmz[count.index].id
}


# # ##################################################################################################################################
# # #Internet Gateway and Routing Tables
# # ##################################################################################################################################

# # //define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = local.con
  tags = merge({
    Name = "Internet Gateway"
  }, var.tags)
}
# //create the route table for outside, inside and DMZ
resource "aws_route_table" "asa_outside_route" {
  vpc_id = local.con
  tags = merge({
    Name = "outside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "asa_inside_route" {
  vpc_id = local.con

  tags = merge({
    Name = "inside network Routing table"
  }, var.tags)
}

resource "aws_route_table" "asa_dmz_route" {
  vpc_id = local.con

  tags = merge({
    Name = "dmz network Routing table"
  }, var.tags)
}

# # //To define the default routes thru IGW
resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.asa_outside_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.create_igw ? aws_internet_gateway.int_gw[0].id : data.aws_internet_gateway.default[0].internet_gateway_id
}

# # //To define the default route for inside network thur ASAv inside interface 
# # #resource "aws_route" "inside_default_route" {
# # #  route_table_id          = aws_route_table.asa_inside_route.id
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
  subnet_id      = var.outside_subnet_cidr != null ? aws_subnet.outside_subnet[count.index].id : data.aws_subnet.outsideasa[count.index].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.mgmt_subnet_cidr != null ? length(var.mgmt_subnet_cidr) : length(var.mgmt_subnet_name)
  subnet_id      = var.mgmt_subnet_cidr != null ? aws_subnet.mgmt_subnet[count.index].id : data.aws_subnet.mgmt[count.index].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "inside_association" {
  count          = var.inside_subnet_cidr != null ? length(var.inside_subnet_cidr) : length(var.inside_subnet_name)
  subnet_id      = var.inside_subnet_cidr != null ? aws_subnet.inside_subnet[count.index].id : data.aws_subnet.insideasa[count.index].id
  route_table_id = aws_route_table.asa_inside_route.id
}


resource "aws_route_table_association" "dmz_association" {
  count          = var.dmz_subnet_cidr != null ? length(var.dmz_subnet_cidr) : length(var.dmz_subnet_name)
  subnet_id      = var.dmz_subnet_cidr != null ? aws_subnet.dmz_subnet[count.index].id : data.aws_subnet.asadmz[count.index].id
  route_table_id = aws_route_table.asa_dmz_route.id
}

# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt and outside interface. 
# # ##################################################################################################################################
# # //External ip address creation 

resource "aws_eip" "asa_mgmt-EIP" {
  count = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.mgmt_subnet_name)
  vpc   = true
  tags = merge({
    "Name" = "asa-${count.index} Management IP"
  }, var.tags)
}


resource "aws_eip" "asa_outside-EIP" {
  count = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
  vpc   = true
  tags = merge({
    "Name" = "asa${count.index} outside IP"
  }, var.tags)
}

resource "aws_eip_association" "asa-mgmt-ip-assocation" {
  count                = length(var.mgmt_interface) != 0 ? length(var.mgmt_interface) : length(var.mgmt_subnet_name)
  network_interface_id = length(var.mgmt_interface) != 0 ? var.mgmt_interface[count.index] : aws_network_interface.asa_mgmt[count.index].id
  allocation_id        = aws_eip.asa_mgmt-EIP[count.index].id
}

resource "aws_eip_association" "asa-outside-ip-association" {
  count                = length(var.outside_interface) != 0 ? length(var.outside_interface) : length(var.outside_subnet_name)
  network_interface_id = length(var.outside_interface) != 0 ? var.outside_interface[count.index] : aws_network_interface.asa_outside[count.index].id
  allocation_id        = aws_eip.asa_outside-EIP[count.index].id
}

