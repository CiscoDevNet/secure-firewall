#########################################################################################################################
# Network
#########################################################################################################################
provider "aws" {
  region = "us-east-1"
  access_key = var.aws_key
  secret_key   = var.aws_secret_key
}
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
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.mgmt_subnet
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.prefix}-Managment subnet"
  }
}

resource "aws_subnet" "diag_subnet" {
  vpc_id = aws_vpc.ftd_vpc.id

  cidr_block        = var.diag_subnet
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.prefix}-diag subnet"
  }
}

resource "aws_subnet" "outside_subnet" {
  vpc_id = aws_vpc.ftd_vpc.id

  cidr_block        = var.outside_subnet
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.prefix}-outside subnet"
  }
}

resource "aws_subnet" "inside_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.inside_subnet
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.prefix}-inside subnet"
  }
}
#################################################################################################################################
# Security Group
#################################################################################################################################

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.ftd_vpc.id

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

##################################################################################################################################
# Network Interfaces, FTD instance, Attaching the SG to interfaces
##################################################################################################################################
resource "aws_network_interface" "ftd01mgmt" {
  description = "ftd01-mgmt"
  subnet_id   = aws_subnet.mgmt_subnet.id
  private_ips = [var.ftd01_mgmt_ip]
}

resource "aws_network_interface" "ftd01diag" {
  description = "ftd01-diag"
  subnet_id   = aws_subnet.diag_subnet.id
}

resource "aws_network_interface" "ftd01outside" {
  description       = "ftd01-outside"
  subnet_id         = aws_subnet.outside_subnet.id
  private_ips       = [var.ftd01_outside_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ftd01inside" {
  description       = "ftd01-inside"
  subnet_id         = aws_subnet.inside_subnet.id
  private_ips       = [var.ftd01_inside_ip]
  source_dest_check = false
}
resource "aws_network_interface" "fmcmgmt" {
  count             = var.create_fmc ? 1 : 0
  description       = "Fmc_Management"
  subnet_id         = aws_subnet.mgmt_subnet.id
  source_dest_check = false
  private_ips       = [var.fmc_ip]
}
resource "aws_network_interface_sg_attachment" "ftd_mgmt_attachment" {
  depends_on           = [aws_network_interface.ftd01mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01mgmt.id
}

resource "aws_network_interface_sg_attachment" "ftd_outside_attachment" {
  depends_on           = [aws_network_interface.ftd01outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01outside.id
}

resource "aws_network_interface_sg_attachment" "ftd_inside_attachment" {
  depends_on           = [aws_network_interface.ftd01inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01inside.id
}
resource "aws_network_interface_sg_attachment" "fmc_attachment" {
  count                = var.create_fmc ? 1 : 0
  depends_on           = [aws_network_interface.fmcmgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.fmcmgmt[0].id
}
##################################################################################################################################
#Internet Gateway and Routing Tables
##################################################################################################################################

//define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.ftd_vpc.id
  tags = {
    Name = "${var.prefix}-Internet Gateway"
  }
}
//create the route table for outsid & inside
resource "aws_route_table" "ftd_outside_route" {
  vpc_id = aws_vpc.ftd_vpc.id

  tags = {
    Name = "${var.prefix}-outside network Routing table"
  }
}

resource "aws_route_table" "ftd_inside_route" {
  vpc_id = aws_vpc.ftd_vpc.id

  tags = {
    Name = "${var.prefix}-inside network Routing table"
  }
}

//To define the default routes thru IGW
resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.ftd_outside_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gw.id
}

//To define the default route for inside network thur FTDv inside interface 
resource "aws_route" "inside_default_route" {
  route_table_id         = aws_route_table.ftd_inside_route.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.ftd01inside.id

}

resource "aws_route_table_association" "outside_association" {
  subnet_id      = aws_subnet.outside_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "mgmt_association" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "inside_association" {
  subnet_id      = aws_subnet.inside_subnet.id
  route_table_id = aws_route_table.ftd_inside_route.id
}
##################################################################################################################################
# AWS External IP address creation and associating it to the mgmt and outside interface. 
##################################################################################################################################
//External ip address creation 

resource "aws_eip" "ftd01mgmt-EIP" {
  domain = "vpc"
  tags = {
    "Name" = "${var.prefix}-FTDv-01 Management IP"
  }
}

resource "aws_eip" "ftd01outside-EIP" {
  domain = "vpc"
  tags = {
    "Name" = "${var.prefix}-FTDv-01 outside IP"
  }
}

resource "aws_eip_association" "ftd01-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.ftd01mgmt.id
  allocation_id        = aws_eip.ftd01mgmt-EIP.id
}
resource "aws_eip_association" "ftd01-outside-ip-association" {
  network_interface_id = aws_network_interface.ftd01outside.id
  allocation_id        = aws_eip.ftd01outside-EIP.id
}

resource "aws_eip" "fmcmgmt-EIP" {
  count  = var.create_fmc ? 1 : 0
  domain = "vpc"
  tags = {
    "Name" = "${var.prefix}-FMCv Management IP"
  }
}
resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  count                = var.create_fmc ? 1 : 0
  network_interface_id = aws_network_interface.fmcmgmt[0].id
  allocation_id        = aws_eip.fmcmgmt-EIP[0].id
}


#########################################################################################################################
# Firewall
#########################################################################################################################



resource "aws_instance" "ftdv" {
  count         = var.create_fmc ? 1 : 0
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftd_size
  key_name      = "${var.prefix}-Cisco-Key"
  network_interface {
    network_interface_id = aws_network_interface.ftd01mgmt.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd01diag.id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd01outside.id
    device_index         = 2
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd01inside.id
    device_index         = 3
  }
  user_data = data.template_file.ftd_startup_file[0].rendered
  tags = {
    Name = "${var.prefix}-Cisco FTDv"
  }
}

resource "aws_instance" "fmcv" {
  count         = var.create_fmc ? 1 : 0
  ami           = data.aws_ami.fmcv[0].id
  instance_type = "c5.4xlarge"
  key_name      = "${var.prefix}-Cisco-Key"
  network_interface {
    network_interface_id = aws_network_interface.fmcmgmt[0].id
    device_index         = 0
  }
  user_data = data.template_file.fmc_startup_file[0].rendered
  tags = {
    Name = "${var.prefix}-Cisco FMCv"
  }
}

##########################################################################
# SSH Keys
##########################################################################

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.key_pair.private_key_openssh
  filename        = "${var.prefix}-Cisco-Key"
  file_permission = 0700
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.prefix}-Cisco-Key"
  public_key = tls_private_key.key_pair.public_key_openssh
}