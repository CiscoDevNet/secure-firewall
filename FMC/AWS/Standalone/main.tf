############################################################################################################################
# Terraform Template to install a FMCv using BYOL AMI with Mgmt subnet
############################################################################################################################

#########################################################################################################################
# Providers
#########################################################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}


#########################################################################################################################
# VPC and Subnet
#########################################################################################################################

resource "aws_vpc" "fmc_vpc" {
  count                = var.vpc_id != "" ? 0 : 1
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mgmt" {
  count = length(local.az_distinct)

  vpc_id            = var.vpc_id != "" ? var.vpc_id : aws_vpc.fmc_vpc[0].id
  availability_zone = local.az_distinct[count.index]
  cidr_block        = length(var.subnets) == 0 ? cidrsubnet(local.vpc_cidr, local.subnet_newbits, count.index) : var.subnets[count.index]
  tags = {
    Name = "${var.name_tag_prefix} Mgmt subnet %{if length(local.az_distinct) > 1}${count.index}%{endif}"
  }
}

#################################################################################################################################
# Security Group
#################################################################################################################################

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : aws_vpc.fmc_vpc[0].id

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
    Name = "${var.name_tag_prefix} Public Allow"
  }
}

##################################################################################################################################
# Network Interfaces, Attaching the SG to interfaces
##################################################################################################################################

resource "aws_network_interface" "mgmt" {
  count             = var.instances
  description       = "%{if length(local.az_distinct) > 1}${local.az_distribution[count.index]}-%{endif}fmc-mgmt"
  subnet_id         = aws_subnet.mgmt[index(local.az_distinct, local.az_distribution[count.index])].id
  source_dest_check = false
}

resource "aws_network_interface_sg_attachment" "fmc_mgmt_attachment" {
  count                = var.instances
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.mgmt[count.index].id
}

##################################################################################################################################
# Internet Gateway and Routing Tables
##################################################################################################################################

resource "aws_internet_gateway" "int_gw" {
  count  = var.igw_id != "" ? 0 : 1
  vpc_id = var.vpc_id != "" ? var.vpc_id : aws_vpc.fmc_vpc[0].id
  tags = {
    Name = "${var.name_tag_prefix} Internet Gateway"
  }
}

resource "aws_route_table" "fmc_mgmt_route" {
  vpc_id = var.vpc_id != "" ? var.vpc_id : aws_vpc.fmc_vpc[0].id

  tags = {
    Name = "${var.name_tag_prefix} Mgmt network Routing table"
  }
}

resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.fmc_mgmt_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id != "" ? var.igw_id : aws_internet_gateway.int_gw[0].id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = length(local.az_distinct)
  subnet_id      = aws_subnet.mgmt[count.index].id
  route_table_id = aws_route_table.fmc_mgmt_route.id
}

##################################################################################################################################
# AWS External IP address creation and associating it to the mgmt interface. 
##################################################################################################################################

resource "aws_eip" "fmc-mgmt-eip" {
  count = var.instances
  vpc   = true
  tags = {
    "Name" = "${var.name_tag_prefix} Management IP%{if var.instances > 1} ${count.index}%{endif}"
  }
}

resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  count                = var.instances
  network_interface_id = aws_network_interface.mgmt[count.index].id
  allocation_id        = aws_eip.fmc-mgmt-eip[count.index].id
}

##################################################################################################################################
# Create the Cisco NGFW Instances (FMCv Instance)
##################################################################################################################################

resource "aws_instance" "fmcv" {
  count         = var.instances
  ami           = data.aws_ami.fmcv.id
  instance_type = var.fmc_size
  key_name      = var.key_name


  network_interface {
    network_interface_id = aws_network_interface.mgmt[count.index].id
    device_index         = 0
  }

  user_data = data.template_file.fmc_startup_file[count.index].rendered

  tags = {
    Name = "Cisco ${var.name_tag_prefix}%{if var.instances > 1} ${count.index}%{endif}"
  }
}
