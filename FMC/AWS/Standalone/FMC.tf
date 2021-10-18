############################################################################################################################
# Terraform Module to install a FMCv using BYOL AMI with Mgmt subnet
############################################################################################################################

#####################################################################################################################
# Variables 
#####################################################################################################################

variable "azs" {
  default     = []
  description = "AWS Availability Zones"
}

variable "name_tag_prefix" {
  default     = "FMCv"
  description = "Prefix for the 'Name' tag of the resources"
}

variable "instances" {
  default     = 1
  description = "Number of FMCv instances"
}

variable "fmc_version" {
  default     = "fmcv-7.0.0"
  description = "Version of the FMCv"
}

variable "fmc_size" {
  default     = "c5.4xlarge"
  description = "Size of the FMCv instance"
}

variable "vpc_name" {
  default     = "Cisco-FMCv"
  description = "VPC Name"
}

variable "vpc_id" {
  default     = ""
  description = "Existing VPC ID"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "subnet_size" {
  default     = 24
  description = "Size of Management subnet"
}

variable "igw_id" {
  default     = ""
  description = "Existing Internet Gateway ID"
}

variable "password" {
  default     = "P@$$w0rd1234"
  description = "Password for FMCv"
  sensitive   = true
}

variable "hostname" {
  default     = "fmc"
  description = "FMCv OS hostname"
}

variable "key_name" {
  description = "AWS EC2 Key"
}

variable "subnets" {
  default     = []
  description = "mgmt subnets"
}

#########################################################################################################################
# Data
#########################################################################################################################

data "aws_vpc" "selected" {
  count = var.vpc_id == "" ? 0 : 1
  id    = var.vpc_id
}

data "aws_availability_zones" "available" {
  count = length(var.azs) > 0 ? 0 : 1
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "fmcv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.fmc_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["bhx85r4r91ls2uwl69ajm9v1b"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  azs             = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.available[0].names
  az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.instances), local.azs), var.instances)[0])), var.instances)[1]
  az_distinct     = distinct(local.az_distribution)
  vpc_cidr        = var.vpc_id != "" ? data.aws_vpc.selected[0].cidr_block : var.vpc_cidr
  subnet_newbits  = var.subnet_size - tonumber(split("/", local.vpc_cidr)[1])
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

  user_data = <<-EOF
#FMC
{
"AdminPassword": "${var.password}",
"Hostname":      "${var.hostname}%{if var.instances > 1}-${count.index}%{endif}",
}
EOF

  tags = {
    Name = "Cisco ${var.name_tag_prefix}%{if var.instances > 1} ${count.index}%{endif}"
  }
}


##################################################################################################################################
#Output
##################################################################################################################################

output "FMCv_EIPs" {
  value = aws_eip.fmc-mgmt-eip[*].public_ip
}
