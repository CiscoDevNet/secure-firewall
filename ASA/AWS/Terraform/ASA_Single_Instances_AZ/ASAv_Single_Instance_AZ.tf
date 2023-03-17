#####################################################################################################################
# Terraform Template to install a Single ASAv in a AZ using BYOL AMI with Mgmt + Three Interfaces in a New VPC
#####################################################################################################################

#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "region" {
        default = "us-east-1"
}

variable "ASA_version" {
    default = "asav9-15-1"
} 

variable "vpc_name" {
    default = "Service-VPC"
}

//defining the VPC CIDR
variable "vpc_cidr" {
    default = "10.1.0.0/16"
}

// defining the subnets variables with the default value for Three Tier Architecure. 

variable "mgmt_subnet" {
    default = "10.1.0.0/24"
}

variable "outside_subnet" {
    default = "10.1.5.0/24"
}

variable "dmz_subnet" {
    default = "10.1.4.0/24"
}

variable "inside_subnet" {
    default = "10.1.3.0/24"
}

variable "asa_mgmt_ip" {
    default = "10.1.0.10"
}

variable "asa_outside_ip" {
    default = "10.1.5.10"
}

variable "asa_inside_ip" {
    default = "10.1.3.10"
}

variable "asa_dmz_ip" {
    default = "10.1.4.10"
}


variable "size" {
  default = "c5.xlarge"
}

//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "NGFW-KP"
}

variable "availability_zone_count" {
  default = 1
}

variable "instances_per_az" {
  default = 1
}

variable "enable_password" {
  default = "P@ssw0rd!"
}

#########################################################################################################################
# data
#########################################################################################################################

data "aws_ami" "asav" {
  most_recent = true      // you can enable this if you want to deploy more
  owners      = ["aws-marketplace"]

 filter {
    name   = "name"
    values = ["${var.ASA_version}*"]
  }


filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "startup_file" {
  template = file("asa_startup_file.txt")
  vars = {
    enable_password = var.enable_password
  }
}

data "aws_availability_zones" "available" {}

#########################################################################################################################
# providers
#########################################################################################################################

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     =  var.region
}

###########################################################################################################################
#VPC Resources 
###########################################################################################################################

resource "aws_vpc" "asa_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mgmt_subnet" {
  count = var.availability_zone_count
  vpc_id            = aws_vpc.asa_vpc.id
  cidr_block        = var.mgmt_subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "var.vpc_name Managment Subnet count.index + 1"
  }
}

resource "aws_subnet" "outside_subnet" {
  count = var.availability_zone_count
  vpc_id            = aws_vpc.asa_vpc.id
  cidr_block        = var.outside_subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "outside subnet"
  }
}

resource "aws_subnet" "inside_subnet" {
  count = var.availability_zone_count
  vpc_id            = aws_vpc.asa_vpc.id
  cidr_block        = var.inside_subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "inside subnet"
  }
}

resource "aws_subnet" "dmz_subnet" {
  count = var.availability_zone_count
  vpc_id            = aws_vpc.asa_vpc.id
  cidr_block        = var.dmz_subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dmz subnet"
  }
}


#################################################################################################################################
# Security Group
#################################################################################################################################

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.asa_vpc.id

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
  vpc_id      = aws_vpc.asa_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "Local Allow"
  }
}

##################################################################################################################################
# Network Interfaces, ASA instance, Attaching the SG to interfaces
##################################################################################################################################
resource "aws_network_interface" "ASA_mgmt" {
  description   = "asa-mgmt"
  count = var.availability_zone_count * var.instances_per_az
  subnet_id     = aws_subnet.mgmt_subnet[floor(count.index / var.instances_per_az)].id
  private_ips   = [var.asa_mgmt_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ASA_outside" {
  description = "asa-outside"
  count = var.availability_zone_count * var.instances_per_az
  subnet_id   = aws_subnet.outside_subnet[floor(count.index / var.instances_per_az)].id
  private_ips = [var.asa_outside_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ASA_inside" {
  description = "asa-inside"
  count = var.availability_zone_count * var.instances_per_az
  subnet_id   = aws_subnet.inside_subnet[floor(count.index / var.instances_per_az)].id
  private_ips = [var.asa_inside_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ASA_dmz" {
  description = "asd-dmz"
  count = var.availability_zone_count * var.instances_per_az
  subnet_id   = aws_subnet.dmz_subnet[floor(count.index / var.instances_per_az)].id
  private_ips = [var.asa_dmz_ip]
  source_dest_check = false
}

resource "aws_network_interface_sg_attachment" "asa_mgmt_attachment" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on           = [aws_network_interface.ASA_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ASA_mgmt[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_outside_attachment" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on           = [aws_network_interface.ASA_outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ASA_outside[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_inside_attachment" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on           = [aws_network_interface.ASA_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ASA_inside[count.index].id
}

resource "aws_network_interface_sg_attachment" "asa_dmz_attachment" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on           = [aws_network_interface.ASA_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ASA_dmz[count.index].id
}

##################################################################################################################################
#Internet Gateway and Routing Tables
##################################################################################################################################

//define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.asa_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}
//create the route table for outside, inside and DMZ
resource "aws_route_table" "asa_outside_route" {
  vpc_id = aws_vpc.asa_vpc.id

  tags = {
    Name = "outside network Routing table"
  }
}

resource "aws_route_table" "asa_inside_route" {
  vpc_id = aws_vpc.asa_vpc.id

  tags = {
    Name = "inside network Routing table"
  }
}

resource "aws_route_table" "asa_dmz_route" {
  vpc_id = aws_vpc.asa_vpc.id

  tags = {
    Name = "dmz network Routing table"
  }
}

//To define the default routes thru IGW
resource "aws_route" "ext_default_route" {
  route_table_id         = aws_route_table.asa_outside_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gw.id
}

//To define the default route for inside network thur ASAv inside interface 
resource "aws_route" "inside_default_route" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on              = [aws_instance.asav]
  route_table_id          = aws_route_table.asa_inside_route.id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.ASA_inside[count.index].id
}

//To define the default route for DMZ network thur ASA inside interface 
resource "aws_route" "DMZ_default_route" {
  count = var.availability_zone_count * var.instances_per_az
  depends_on              = [aws_instance.asav]  
  route_table_id          = aws_route_table.asa_dmz_route.id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.ASA_dmz[count.index].id
}

resource "aws_route_table_association" "outside_association" {
  count = var.availability_zone_count * var.instances_per_az
  subnet_id      = aws_subnet.outside_subnet[count.index].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "mgmt_association" {
   count = var.availability_zone_count * var.instances_per_az
  subnet_id      = aws_subnet.mgmt_subnet[count.index].id
  route_table_id = aws_route_table.asa_outside_route.id
}

resource "aws_route_table_association" "inside_association" {
  count = var.availability_zone_count * var.instances_per_az
  subnet_id      = aws_subnet.inside_subnet[count.index].id
  route_table_id = aws_route_table.asa_inside_route.id
}

resource "aws_route_table_association" "dmz_association" {
  count = var.availability_zone_count * var.instances_per_az
  subnet_id      = aws_subnet.dmz_subnet[count.index].id
  route_table_id = aws_route_table.asa_dmz_route.id
}
##################################################################################################################################
# AWS External IP address creation and associating it to the mgmt and outside interface. 
##################################################################################################################################
//External ip address creation 

resource "aws_eip" "asa_mgmt-EIP" {
  count = var.availability_zone_count * var.instances_per_az
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw]
  tags = {
    "Name" = "ASA Management IP"
  }
}

resource "aws_eip" "asa_outside-EIP" {
  count = var.availability_zone_count * var.instances_per_az
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw]
  tags = {
    "Name" = "ASA outside IP"
  }
}

resource "aws_eip_association" "asa-mgmt-ip-assocation" {
  count = var.availability_zone_count * var.instances_per_az
  network_interface_id = aws_network_interface.ASA_mgmt[count.index].id
  allocation_id        = aws_eip.asa_mgmt-EIP[count.index].id
}
resource "aws_eip_association" "asa-outside-ip-association" {
  count = var.availability_zone_count * var.instances_per_az
  network_interface_id = aws_network_interface.ASA_outside[count.index].id
  allocation_id        = aws_eip.asa_outside-EIP[count.index].id
}

##################################################################################################################################
# Create the Cisco NGFW Instances 
##################################################################################################################################
resource "aws_instance" "asav" {
  count = var.availability_zone_count * var.instances_per_az
  ami                 = data.aws_ami.asav.id
  instance_type       = var.size 
  key_name            = var.key_name
    
  network_interface {
    network_interface_id = aws_network_interface.ASA_mgmt[count.index].id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.ASA_outside[count.index].id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.ASA_inside[count.index].id
    device_index         = 2
  }

  network_interface {
    network_interface_id = aws_network_interface.ASA_dmz[count.index].id
    device_index         = 3
  }
  
  user_data = data.template_file.startup_file.rendered


  tags = {
    Name = "Cisco ASAv"
  }
}

##################################################################################################################################
#Output
##################################################################################################################################
output "ip" {
  value = aws_eip.asa_mgmt-EIP.*.public_ip
}
