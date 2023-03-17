#####################################################################################################################
# Terraform Template to install a Single FTDv in a AZ using BYOL AMI with Mgmt + Diag + Three Interfaces in a New VPC
#####################################################################################################################

#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "region" {
        default = "us-east-2"
}

variable "FTD_version" {
    default = "ftdv-6.7.0"
} 

variable "vpc_name" {
    default = "Service-VPC"
}

//Including the Avilability Zone
variable "aws_az" {
    default = "us-east-2a"
}

//defining the VPC CIDR
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

// defining the subnets variables with the default value for Three Tier Architecure. 

variable "mgmt_subnet" {
    default = "10.0.1.0/24"
}

variable "ftd01_mgmt_ip" {
    default = "10.0.1.10"
}

variable "ftd01_outside_ip" {
    default = "10.0.5.10"
}

variable "ftd01_inside_ip" {
    default = "10.0.3.10"
}
        
variable "ftd01_diag_ip" {
    default = "10.0.2.10"
}        

variable "ftd01_dmz_ip" {
    default = "10.0.4.10"
}

variable "diag_subnet" {
    default = "10.0.2.0/24"
}

variable "outside_subnet" {
    default = "10.0.5.0/24"
}

variable "dmz_subnet" {
    default = "10.0.4.0/24"
}

variable "inside_subnet" {
    default = "10.0.3.0/24"
}

variable "size" {
  default = "c5.4xlarge"
}

//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "NGFW-KP"
}

#########################################################################################################################
# data
#########################################################################################################################

data "aws_ami" "ftdv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners      = ["aws-marketplace"]

 filter {
    name   = "name"
    values = ["${var.FTD_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "startup_file" {
  template = file("startup_file.txt")
}
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

resource "aws_vpc" "ftd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mgmt_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.mgmt_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "Managment subnet"
  }
}

resource "aws_subnet" "diag_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.diag_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "diag subnet"
  }
}

resource "aws_subnet" "outside_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.outside_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "outside subnet"
  }
}

resource "aws_subnet" "dmz_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.dmz_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "dmz subnet"
  }
}

resource "aws_subnet" "inside_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.inside_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "inside subnet"
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

resource "aws_default_security_group" "default" {
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
  description   = "ftd01-mgmt"
  subnet_id     = aws_subnet.mgmt_subnet.id
  private_ips   = [var.ftd01_mgmt_ip]
}

resource "aws_network_interface" "ftd01diag" {
  description = "ftd01-diag"
  subnet_id   = aws_subnet.diag_subnet.id
}

resource "aws_network_interface" "ftd01outside" {
  description = "ftd01-outside"
  subnet_id   = aws_subnet.outside_subnet.id
  private_ips = [var.ftd01_outside_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ftd01inside" {
  description = "ftd01-inside"
  subnet_id   = aws_subnet.inside_subnet.id
  private_ips = [var.ftd01_inside_ip]
  source_dest_check = false
}

resource "aws_network_interface" "ftd01dmz" {
  description = "ftd01-dmz"
  subnet_id   = aws_subnet.dmz_subnet.id
  private_ips = [var.ftd01_dmz_ip]
  source_dest_check = false
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

resource "aws_network_interface_sg_attachment" "ftd_dmz_attachment" {
  depends_on           = [aws_network_interface.ftd01dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01dmz.id
}

##################################################################################################################################
#Internet Gateway and Routing Tables
##################################################################################################################################

//define the internet gateway
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.ftd_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}
//create the route table for outside, inside and DMZ
resource "aws_route_table" "ftd_outside_route" {
  vpc_id = aws_vpc.ftd_vpc.id

  tags = {
    Name = "outside network Routing table"
  }
}

resource "aws_route_table" "ftd_inside_route" {
  vpc_id = aws_vpc.ftd_vpc.id

  tags = {
    Name = "inside network Routing table"
  }
}

resource "aws_route_table" "ftd_dmz_route" {
  vpc_id = aws_vpc.ftd_vpc.id

  tags = {
    Name = "dmz network Routing table"
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
  depends_on              = [aws_instance.ftdv]
  route_table_id          = aws_route_table.ftd_inside_route.id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.ftd01inside.id

}

//To define the default route for DMZ network thur FTDv inside interface 
resource "aws_route" "DMZ_default_route" {
  depends_on              = [aws_instance.ftdv]  
  route_table_id          = aws_route_table.ftd_dmz_route.id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.ftd01dmz.id

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

resource "aws_route_table_association" "dmz_association" {
  subnet_id      = aws_subnet.dmz_subnet.id
  route_table_id = aws_route_table.ftd_dmz_route.id
}
##################################################################################################################################
# AWS External IP address creation and associating it to the mgmt and outside interface. 
##################################################################################################################################
//External ip address creation 

resource "aws_eip" "ftd01mgmt-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv]
  tags = {
    "Name" = "FTDv-01 Management IP"
  }
}

resource "aws_eip" "ftd01outside-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv]
  tags = {
    "Name" = "FTDv-01 outside IP"
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

##################################################################################################################################
# Create the Cisco NGFW Instances 
##################################################################################################################################
resource "aws_instance" "ftdv" {
    ami                 = data.aws_ami.ftdv.id
    instance_type       = var.size 
    key_name            = var.key_name
    availability_zone   = var.aws_az
    
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

    network_interface {
    network_interface_id = aws_network_interface.ftd01dmz.id
    device_index         = 4
  }
  
  user_data = data.template_file.startup_file.rendered


  tags = {
    Name = "Cisco FTDv"
  }
}

##################################################################################################################################
#Output
##################################################################################################################################
output "ip" {
  value = aws_eip.ftd01mgmt-EIP.public_ip
}