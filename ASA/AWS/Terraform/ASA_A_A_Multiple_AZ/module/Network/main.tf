resource "aws_vpc" "asa_vpc" {
  count                = var.vpc_cidr != null ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mgmt01_subnet" {
  count             = var.mgmt01_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.mgmt01_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = var.mgmt01_subnet_name
  }
}

resource "aws_subnet" "mgmt02_subnet" {
  count             = var.mgmt02_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.mgmt02_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.mgmt02_subnet_name
  }
}


resource "aws_subnet" "outside01_subnet" {
  count             = var.outside01_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.outside01_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.outside01_subnet_name
  }
}

resource "aws_subnet" "outside02_subnet" {
  count             = var.outside02_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.outside02_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.outside02_subnet_name
  }
}

resource "aws_subnet" "inside01_subnet" {
  count             = var.inside01_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.inside01_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.inside01_subnet_name
  }
}

resource "aws_subnet" "inside02_subnet" {
  count             = var.inside02_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.inside02_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.inside02_subnet_name
  }
}

resource "aws_subnet" "dmz01_subnet" {
  count             = var.dmz01_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.dmz01_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.dmz01_subnet_name
  }
}

resource "aws_subnet" "dmz02_subnet" {
  count             = var.dmz02_subnet_cidr != null ? 1 : 0
  vpc_id            = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  cidr_block        = var.dmz02_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.dmz02_subnet_name
  }
}



# # #################################################################################################################################
# # # Security Group
# # #################################################################################################################################

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Allow"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr != null ? aws_vpc.asa_vpc[0].cidr_block : data.aws_vpc.asa_vpc[0].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr != null ? aws_vpc.asa_vpc[0].cidr_block : data.aws_vpc.asa_vpc[0].cidr_block]
  }

  tags = {
    Name = "Local Allow"
  }
}



# # ##################################################################################################################################
# # # Network Interfaces, ASA instance, Attaching the SG to interfaces
# # ##################################################################################################################################
resource "aws_network_interface" "asa01_mgmt" {
  description       = "asa01-mgmt"
  subnet_id         = var.mgmt01_subnet_cidr != null ? aws_subnet.mgmt01_subnet[0].id : data.aws_subnet.mgmt01[0].id
  source_dest_check = false
  private_ips       = [var.asa01_mgmt_ip]
}

resource "aws_network_interface" "asa02_mgmt" {
  description       = "asa02-mgmt"
  subnet_id         = var.mgmt02_subnet_cidr != null ? aws_subnet.mgmt02_subnet[0].id : data.aws_subnet.mgmt02[0].id
  source_dest_check = false
  private_ips       = [var.asa02_mgmt_ip]
}

resource "aws_network_interface" "asa01_outside" {

  description       = "asa01-outside"
  subnet_id         = var.outside01_subnet_cidr != null ? aws_subnet.outside01_subnet[0].id : data.aws_subnet.outsideasa01[0].id
  source_dest_check = false
  private_ips       = [var.asa01_outside_ip]
}

resource "aws_network_interface" "asa02_outside" {

  description       = "asa02-outside"
  subnet_id         = var.outside02_subnet_cidr != null ? aws_subnet.outside02_subnet[0].id : data.aws_subnet.outsideasa02[0].id
  source_dest_check = false
  private_ips       = [var.asa02_outside_ip]
}

resource "aws_network_interface" "asa01_inside" {

  description       = "asa01-inside"
  subnet_id         = var.inside01_subnet_cidr != null ? aws_subnet.inside01_subnet[0].id : data.aws_subnet.insideasa01[0].id
  source_dest_check = false
  private_ips       = [var.asa01_inside_ip]
}

resource "aws_network_interface" "asa02_inside" {

  description       = "asa02-inside"
  subnet_id         = var.inside02_subnet_cidr != null ? aws_subnet.inside02_subnet[0].id : data.aws_subnet.insideasa02[0].id
  source_dest_check = false
  private_ips       = [var.asa02_inside_ip]
}

resource "aws_network_interface" "asa01_dmz" {
  description       = "asa01-dmz"
  subnet_id         = var.dmz01_subnet_cidr != null ? aws_subnet.dmz01_subnet[0].id : data.aws_subnet.asa01dmz[0].id
  source_dest_check = false
  private_ips       = [var.asa01_dmz_ip]

}

resource "aws_network_interface" "asa02_dmz" {
  description       = "asa02-dmz"
  subnet_id         = var.dmz02_subnet_cidr != null ? aws_subnet.dmz02_subnet[0].id : data.aws_subnet.asa02dmz[0].id
  source_dest_check = false
  private_ips       = [var.asa02_dmz_ip]

}

resource "aws_network_interface_sg_attachment" "asa01_mgmt_attachment" {
  depends_on           = [aws_network_interface.asa01_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa01_mgmt.id
}

resource "aws_network_interface_sg_attachment" "asa02_mgmt_attachment" {
  depends_on           = [aws_network_interface.asa02_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa02_mgmt.id
}

resource "aws_network_interface_sg_attachment" "asa01_outside_attachment" {
  depends_on           = [aws_network_interface.asa01_outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa01_outside.id
}

resource "aws_network_interface_sg_attachment" "asa02_outside_attachment" {
  depends_on           = [aws_network_interface.asa02_outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa02_outside.id
}

resource "aws_network_interface_sg_attachment" "asa01_inside_attachment" {
  depends_on           = [aws_network_interface.asa01_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa01_inside.id
}

resource "aws_network_interface_sg_attachment" "asa02_inside_attachment" {
  depends_on           = [aws_network_interface.asa02_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa02_inside.id
}

resource "aws_network_interface_sg_attachment" "asa01_dmz_attachment" {
  depends_on           = [aws_network_interface.asa01_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa01_dmz.id
}

resource "aws_network_interface_sg_attachment" "asa02_dmz_attachment" {
  depends_on           = [aws_network_interface.asa02_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.asa02_dmz.id
}

# # ##################################################################################################################################
# # #Internet Gateway and Routing Tables
# # ##################################################################################################################################

# # //define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  count  = var.vpc_cidr != null ? 1 : 0
  vpc_id = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  tags = {
    Name = "Internet Gateway"
  }
}
# //create the route table for outside, inside and DMZ
resource "aws_route_table" "asa_outside_route" {
  vpc_id = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  tags = {
    Name = "outside network Routing table"
  }
}

resource "aws_route_table" "asa_inside_route" {
  vpc_id = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id

  tags = {
    Name = "inside network Routing table"
  }
}

resource "aws_route_table" "asa_dmz_route" {
  vpc_id = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id

  tags = {
    Name = "dmz network Routing table"
  }
}

# # //To define the default routes thru IGW
resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.asa_outside_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.vpc_cidr != null ? aws_internet_gateway.int_gw[0].id : data.aws_internet_gateway.default[0].internet_gateway_id
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

resource "aws_route_table_association" "outside01_association" {
  subnet_id      = var.outside01_subnet_cidr != null ? aws_subnet.outside01_subnet[0].id : data.aws_subnet.outsideasa01[0].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "outside02_association" {
  subnet_id      = var.outside02_subnet_cidr != null ? aws_subnet.outside02_subnet[0].id : data.aws_subnet.outsideasa02[0].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "mgmt01_association" {
  subnet_id      = var.mgmt01_subnet_cidr != null ? aws_subnet.mgmt01_subnet[0].id : data.aws_subnet.mgmt01[0].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "mgmt02_association" {
  subnet_id      = var.mgmt01_subnet_cidr != null ? aws_subnet.mgmt01_subnet[0].id : data.aws_subnet.mgmt02[0].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "inside01_association" {
  subnet_id      = var.inside01_subnet_cidr != null ? aws_subnet.inside01_subnet[0].id : data.aws_subnet.insideasa01[0].id
  route_table_id = aws_route_table.asa_inside_route.id
}

resource "aws_route_table_association" "inside02_association" {
  subnet_id      = var.inside02_subnet_cidr != null ? aws_subnet.inside02_subnet[0].id : data.aws_subnet.insideasa02[0].id
  route_table_id = aws_route_table.asa_inside_route.id
}

resource "aws_route_table_association" "dmz01_association" {
  subnet_id      = var.dmz01_subnet_cidr != null ? aws_subnet.dmz01_subnet[0].id : data.aws_subnet.asa01dmz[0].id
  route_table_id = aws_route_table.asa_dmz_route.id
}

resource "aws_route_table_association" "dmz02_association" {
  subnet_id      = var.dmz02_subnet_cidr != null ? aws_subnet.dmz02_subnet[0].id : data.aws_subnet.asa02dmz[0].id
  route_table_id = aws_route_table.asa_dmz_route.id
}


# # ##################################################################################################################################
# # # AWS External IP address creation and associating it to the mgmt and outside interface. 
# # ##################################################################################################################################
# # //External ip address creation 

resource "aws_eip" "asa01_mgmt-EIP" {
  vpc = true
  tags = {
    "Name" = "asa01 Management IP"
  }
}

resource "aws_eip" "asa02_mgmt-EIP" {
  vpc = true
  tags = {
    "Name" = "asa02 Management IP"
  }
}


resource "aws_eip" "asa01_outside-EIP" {
  vpc = true
  tags = {
    "Name" = "asa01 outside IP"
  }
}

resource "aws_eip" "asa02_outside-EIP" {
  vpc = true
  tags = {
    "Name" = "asa02 outside IP"

  }
}

resource "aws_eip_association" "asa01-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.asa01_mgmt.id
  allocation_id        = aws_eip.asa01_mgmt-EIP.id
}

resource "aws_eip_association" "asa02-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.asa02_mgmt.id
  allocation_id        = aws_eip.asa02_mgmt-EIP.id
}

resource "aws_eip_association" "asa01-outside-ip-association" {
  network_interface_id = aws_network_interface.asa01_outside.id
  allocation_id        = aws_eip.asa01_outside-EIP.id
}

resource "aws_eip_association" "asa02-outside-ip-association" {
  network_interface_id = aws_network_interface.asa02_outside.id
  allocation_id        = aws_eip.asa02_outside-EIP.id
}
