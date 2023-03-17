############################################################################################################################
# Terraform Template to install a Two FTDv and FMCv in Multiple AZ using BYOL AMI with Mgmt + Three Interfaces in a New VPC
############################################################################################################################

#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "region" {
        default = "us-east-1"
}
variable "FTD_version" {
    default = "ftdv-6.7.0"
} 

variable "FMC_version" {
    default = "fmcv-6.7.0"
} 

variable "vpc_name" {
    default = "Service-VPC"
}

//defining the VPC CIDR
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

// defining the subnets variables with the default value for Three Tier Architecure. 

variable "mgmt01_subnet" {
    default = "10.0.1.0/24"
}

variable "mgmt02_subnet" {
    default = "10.0.10.0/24"
}

variable "ftd01_mgmt_ip" {
    default = "10.0.1.10"
}

variable "ftd02_mgmt_ip" {
    default = "10.0.10.20"
}

variable "fmc_mgmt_ip" {
  default = "10.0.1.50"
}

variable "fmc_nat_id" {
  default = ""
}

variable "outside01_subnet" {
    default = "10.0.5.0/24"
}

variable "outside02_subnet" {
    default = "10.0.50.0/24"
}

variable "ftd01_outside_ip" {
    default = "10.0.5.10"
}

variable "ftd02_outside_ip" {
    default = "10.0.50.20"
}

variable "dmz01_subnet" {
    default = "10.0.4.0/24"
}

variable "dmz02_subnet" {
    default = "10.0.40.0/24"
}

variable "ftd01_dmz_ip" {
    default = "10.0.4.10"
}

variable "ftd02_dmz_ip" {
    default = "10.0.40.20"
}

variable "inside01_subnet" {
    default = "10.0.3.0/24"
}

variable "inside02_subnet" {
    default = "10.0.30.0/24"
}

variable "ftd01_inside_ip" {
    default = "10.0.3.10"
}

variable "ftd02_inside_ip" {
    default = "10.0.30.20"
}

variable "ftd_size" {
  default = "c5.4xlarge"
}

//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "NGFW-KP"

}

variable "fmc_size" {
  default = "c5.4xlarge"
}


variable "availability_zone_count" {
  default = 2
}

variable "instances_per_az" {
  default = 2
}

variable "listener_ports" {
  default = {
    22  = "TCP"
    443 = "TCP"
  }
}

variable "health_check" {
  default = {
    protocol = "TCP"
    port = 22
  }
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

//Defining the FMCv AMI based on the version
data "aws_ami" "fmcv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners      = ["aws-marketplace"]

 filter {
    name   = "name"
    values = ["${var.FMC_version}*"]
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


data "template_file" "ftd_startup_file" {
    count = var.instances_per_az * var.availability_zone_count
    template = file("ftd_startup_file.txt")
    vars = {
    fmc_ip       = var.fmc_mgmt_ip
    fmc_nat_id   = var.fmc_nat_id
    }
}

data "template_file" "fmc_startup_file" {
  template = file("fmc_startup_file.txt")
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

resource "aws_vpc" "ftd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mgmt01_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.mgmt01_subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "mgmt AZ1 subnet"
  }
}

resource "aws_subnet" "mgmt02_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.mgmt02_subnet
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "mgmt AZ2 subnet"
  }
}

resource "aws_subnet" "outside01_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.outside01_subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "outside AZ1 subnet"
  }
}

resource "aws_subnet" "outside02_subnet" {
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.outside02_subnet
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "outside AZ2 subnet"
  }
}

resource "aws_subnet" "inside01_subnet" {
  
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.inside01_subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "inside AZ1 subnet"
  }
}

resource "aws_subnet" "inside02_subnet" {
 
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.inside02_subnet
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "inside AZ2 subnet"
  }
}

resource "aws_subnet" "dmz01_subnet" {

  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.dmz01_subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "dmz AZ1 subnet"
  }
}

resource "aws_subnet" "dmz02_subnet" {
  
  vpc_id            = aws_vpc.ftd_vpc.id
  cidr_block        = var.dmz02_subnet
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "dmz AZ1 subnet"
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
    Name = "Local Allow"
  }
}

##################################################################################################################################
# Network Interfaces, FTD instance, Attaching the SG to interfaces
##################################################################################################################################
resource "aws_network_interface" "ftd01_mgmt" {
  description   = "ftd01-mgmt"
  subnet_id     = aws_subnet.mgmt01_subnet.id
  source_dest_check = false
  private_ips = [var.ftd01_mgmt_ip]
}

resource "aws_network_interface" "ftd02_mgmt" {
  description   = "ftd02-mgmt"
  subnet_id     = aws_subnet.mgmt02_subnet.id
  source_dest_check = false
  private_ips = [var.ftd02_mgmt_ip]
}

resource "aws_network_interface" "fmcmgmt" {
  description   = "fmc-mgmt"
  subnet_id     = aws_subnet.mgmt01_subnet.id
  source_dest_check = false
  private_ips = [var.fmc_mgmt_ip]
}

resource "aws_network_interface" "ftd01_diag" {
  description   = "ftd01-diag"
  subnet_id     = aws_subnet.mgmt01_subnet.id
}

resource "aws_network_interface" "ftd02_diag" {
  description   = "ftd02-diag"
  subnet_id     = aws_subnet.mgmt02_subnet.id
}

resource "aws_network_interface" "ftd01_outside" {
  
  description = "ftd01-outside"
  subnet_id   = aws_subnet.outside01_subnet.id
  source_dest_check = false
  private_ips = [var.ftd01_outside_ip]
}

resource "aws_network_interface" "ftd02_outside" {
  
  description = "ftd02-outside"
  subnet_id   = aws_subnet.outside02_subnet.id
  source_dest_check = false
  private_ips = [var.ftd02_outside_ip]
  
}

resource "aws_network_interface" "ftd01_inside" {
  
  description = "ftd01-inside"
  subnet_id   = aws_subnet.inside01_subnet.id
  source_dest_check = false
  private_ips = [var.ftd01_inside_ip]
}

resource "aws_network_interface" "ftd02_inside" {
  
  description = "ftd02-inside"
  subnet_id   = aws_subnet.inside02_subnet.id
  source_dest_check = false
  private_ips = [var.ftd02_inside_ip]
}

resource "aws_network_interface" "ftd01_dmz" {
  description = "ftd01-dmz"
  subnet_id   = aws_subnet.dmz01_subnet.id
  source_dest_check = false
  private_ips = [var.ftd01_dmz_ip]

}

resource "aws_network_interface" "ftd02_dmz" {
  description = "ftd02-dmz"
  subnet_id   = aws_subnet.dmz02_subnet.id
  source_dest_check = false
  private_ips = [var.ftd02_dmz_ip]

}

resource "aws_network_interface_sg_attachment" "ftd01_mgmt_attachment" {
  depends_on           = [aws_network_interface.ftd01_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01_mgmt.id
}

resource "aws_network_interface_sg_attachment" "ftd02_mgmt_attachment" {
  depends_on           = [aws_network_interface.ftd02_mgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd02_mgmt.id
}

resource "aws_network_interface_sg_attachment" "ftd01_outside_attachment" {
  depends_on           = [aws_network_interface.ftd01_outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01_outside.id
}

resource "aws_network_interface_sg_attachment" "ftd02_outside_attachment" {
  depends_on           = [aws_network_interface.ftd02_outside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd02_outside.id
}

resource "aws_network_interface_sg_attachment" "ftd01_inside_attachment" {
  depends_on           = [aws_network_interface.ftd01_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01_inside.id
}

resource "aws_network_interface_sg_attachment" "ftd02_inside_attachment" {
  depends_on           = [aws_network_interface.ftd02_inside]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd02_inside.id
}

resource "aws_network_interface_sg_attachment" "ftd01_dmz_attachment" {
  depends_on           = [aws_network_interface.ftd01_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd01_dmz.id
}

resource "aws_network_interface_sg_attachment" "ftd02_dmz_attachment" {
  depends_on           = [aws_network_interface.ftd02_dmz]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.ftd02_dmz.id
}

resource "aws_network_interface_sg_attachment" "fmc_mgmt_attachment" {
  depends_on           = [aws_network_interface.fmcmgmt]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.fmcmgmt.id
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
#resource "aws_route" "inside_default_route" {
#  depends_on              = [aws_instance.ftdv01]
#  route_table_id          = aws_route_table.ftd_inside_route.id
#  destination_cidr_block  = "0.0.0.0/0"
#  network_interface_id    = aws_network_interface.ftd01_inside.id
#}

//To define the default route for DMZ network thur FTD DMZ interface 
#resource "aws_route" "DMZ_default_route" {
#  depends_on              = [aws_instance.ftdv01]  
#  route_table_id          = aws_route_table.ftd_dmz_route.id
#  destination_cidr_block  = "0.0.0.0/0"
#  network_interface_id    = aws_network_interface.ftd01_dmz.id
#}

resource "aws_route_table_association" "outside01_association" {
  subnet_id      = aws_subnet.outside01_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "outside02_association" {
  subnet_id      = aws_subnet.outside02_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "mgmt01_association" {
  subnet_id      = aws_subnet.mgmt01_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "mgmt02_association" {
  subnet_id      = aws_subnet.mgmt02_subnet.id
  route_table_id = aws_route_table.ftd_outside_route.id
}

resource "aws_route_table_association" "inside01_association" {
  subnet_id      = aws_subnet.inside01_subnet.id
  route_table_id = aws_route_table.ftd_inside_route.id
}

resource "aws_route_table_association" "inside02_association" {
  subnet_id      = aws_subnet.inside02_subnet.id
  route_table_id = aws_route_table.ftd_inside_route.id
}

resource "aws_route_table_association" "dmz01_association" {
  subnet_id      = aws_subnet.dmz01_subnet.id
  route_table_id = aws_route_table.ftd_dmz_route.id
}

resource "aws_route_table_association" "dmz02_association" {
  subnet_id      = aws_subnet.dmz02_subnet.id
  route_table_id = aws_route_table.ftd_dmz_route.id
}

##################################################################################################################################
# AWS External IP address creation and associating it to the mgmt and outside interface. 
##################################################################################################################################
//External ip address creation 
resource "aws_eip" "ftd01_mgmt-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv01]
  tags = {
    "Name" = "ftd01 Management IP"
  }
}

resource "aws_eip" "ftd02_mgmt-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv02]
  tags = {
    "Name" = "ftd02 Management IP"
  }
}


resource "aws_eip" "ftd01_outside-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv01]
  tags = {
    "Name" = "ftd01 outside IP"
  }
}

resource "aws_eip" "ftd02_outside-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.ftdv02]
  tags = {
    "Name" = "ftd02 outside IP"
    
  }
}

resource "aws_eip" "fmcmgmt-EIP" {
  vpc   = true
  depends_on = [aws_internet_gateway.int_gw,aws_instance.fmcv]
  tags = {
    "Name" = "FMCv Management IP"
  }
}

resource "aws_eip_association" "ftd01-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.ftd01_mgmt.id
  allocation_id        = aws_eip.ftd01_mgmt-EIP.id
}

resource "aws_eip_association" "ftd02-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.ftd02_mgmt.id
  allocation_id        = aws_eip.ftd02_mgmt-EIP.id
}

resource "aws_eip_association" "ftd01-outside-ip-association" {
  network_interface_id = aws_network_interface.ftd01_outside.id
  allocation_id        = aws_eip.ftd01_outside-EIP.id
}

resource "aws_eip_association" "ftd02-outside-ip-association" {
  network_interface_id = aws_network_interface.ftd02_outside.id
  allocation_id        = aws_eip.ftd02_outside-EIP.id
}

resource "aws_eip_association" "fmc-mgmt-ip-assocation" {
  network_interface_id = aws_network_interface.fmcmgmt.id
  allocation_id        = aws_eip.fmcmgmt-EIP.id
}

##################################################################################################################################
# Create the Cisco FTD01 Instances (First Instance)
##################################################################################################################################

resource "aws_instance" "ftdv01" {
    ami                 = data.aws_ami.ftdv.id
    instance_type       = var.ftd_size 
    key_name            = var.key_name
    
network_interface {
    network_interface_id = aws_network_interface.ftd01_mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.ftd01_diag.id
    device_index         = 1
  }

   network_interface {
    network_interface_id = aws_network_interface.ftd01_outside.id
    device_index         = 2
  }

    network_interface {
    network_interface_id = aws_network_interface.ftd01_inside.id
    device_index         = 3
  }

    network_interface {
    network_interface_id = aws_network_interface.ftd01_dmz.id
    device_index         = 4
  }
  
  user_data = data.template_file.ftd_startup_file[1].rendered


  tags = {
    Name = "Cisco ftdv01"
  }
}

##################################################################################################################################
# Create the Cisco FTD02 Instances (Secound Instance)
##################################################################################################################################

resource "aws_instance" "ftdv02" {
    ami                 = data.aws_ami.ftdv.id
    instance_type       = var.ftd_size 
    key_name            = var.key_name
    
network_interface {
    network_interface_id = aws_network_interface.ftd02_mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.ftd02_diag.id
    device_index         = 1
  }

   network_interface {
    network_interface_id = aws_network_interface.ftd02_outside.id
    device_index         = 2
  }

    network_interface {
    network_interface_id = aws_network_interface.ftd02_inside.id
    device_index         = 3
  }

    network_interface {
    network_interface_id = aws_network_interface.ftd02_dmz.id
    device_index         = 4
  }
  
  user_data = data.template_file.ftd_startup_file[0].rendered


  tags = {
    Name = "Cisco ftdv02"
  }
}

##################################################################################################################################
# Create the Cisco NGFW Instances (FMCv Instance)
##################################################################################################################################

resource "aws_instance" "fmcv" {
    ami                 = data.aws_ami.fmcv.id
    instance_type       = var.fmc_size 
    key_name            = var.key_name
    
    
network_interface {
    network_interface_id = aws_network_interface.fmcmgmt.id
    device_index         = 0
  }

  user_data = data.template_file.fmc_startup_file.rendered


  tags = {
    Name = "Cisco FMCv"
  }
}

#########################################################################################################
# Creation of Load Balancer
#########################################################################################################

resource "aws_lb" "external01-lb" {

  name                                = "External01-LB"
  load_balancer_type                  = "network"
  enable_cross_zone_load_balancing    = "true"

  subnet_mapping {
    subnet_id     = aws_subnet.outside01_subnet.id
    
  }
  subnet_mapping {
    subnet_id     = aws_subnet.outside02_subnet.id
    
  }
}

#resource "aws_lb" "external02-lb" {

#  name                               = "External02-LB"
#  load_balancer_type                 = "network"
#  enable_cross_zone_load_balancing   = "true"


#  subnet_mapping {
#    subnet_id     = aws_subnet.outside02_subnet.id
    
#  }
#  subnet_mapping {
#    subnet_id     = aws_subnet.outside01_subnet.id
    
#  }
#}

resource "aws_lb" "internal01-lb" {
  name                                = "Inside01-LB"
  load_balancer_type                  = "network"
  enable_cross_zone_load_balancing    = "true"


  subnet_mapping {
    subnet_id = aws_subnet.inside01_subnet.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.inside02_subnet.id
  }
}


#resource "aws_lb" "internal02-lb" {
#  name                                = "Inside02-LB"
#  load_balancer_type                  = "network"
#  enable_cross_zone_load_balancing    = "true"



#  subnet_mapping {
#    subnet_id = aws_subnet.inside01_subnet.id
#  }
#  subnet_mapping {
#    subnet_id = aws_subnet.inside02_subnet.id
#  }
#}


resource "aws_lb_listener" "listener1-1" {
  load_balancer_arn = aws_lb.external01-lb.arn
  for_each          = var.listener_ports
  port              = each.key
  protocol          = each.value
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  } 
}

#resource "aws_lb_listener" "listener1-2" {
#  load_balancer_arn = aws_lb.external02-lb.arn
#  for_each          = var.listener_ports
#  port              = each.key
#  protocol          = each.value
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
#  }
#}

#####################################################################
//optional -- Only required when you want to use Internal LB.
###################################################################### 
#resource "aws_lb_listener" "listener2-1" {
# load_balancer_arn = aws_lb.internal01-lb.arn
# for_each = var.listener_ports
# port = each.key
# protocol = each.value
# default_action {
# type = "forward"
# target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# }
#}
#resource "aws_lb_listener" "listener2-2" {
# load_balancer_arn = aws_lb.internal02-lb.arn
# for_each = var.listener_ports
# port = each.key
# protocol = each.value
# default_action {
# type = "forward"
# target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# }
#}

resource "aws_lb_target_group" "front_end1-1" {
  for_each = var.listener_ports
  name = tostring("fe1-1-${each.key}")
  port = each.key
  protocol = each.value
  target_type = "ip"
  vpc_id = aws_vpc.ftd_vpc.id
  
  health_check {
    interval = 30
    protocol = var.health_check.protocol
    port = var.health_check.port
    }
}

resource "aws_lb_target_group" "front_end1-2" {
  for_each = var.listener_ports
  name = tostring("fe1-2-${each.key}")
  port = each.key
  protocol = each.value
  target_type = "ip"
  vpc_id = aws_vpc.ftd_vpc.id
  
  health_check {
    interval = 30
    protocol = var.health_check.protocol
    port = var.health_check.port
    }
}

resource "aws_lb_target_group_attachment" "target1_1a" {
  for_each = var.listener_ports
  depends_on = [aws_lb_target_group.front_end1-1]
  target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  target_id = var.ftd01_outside_ip
  
  }

#resource "aws_lb_target_group_attachment" "target1_1b" {
#  for_each = var.listener_ports
#  depends_on = [aws_lb_target_group.front_end1-2]
#  target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
#  target_id = var.ftd01_outside_ip
#}

resource "aws_lb_target_group_attachment" "target1_2a" {
  for_each = var.listener_ports
  depends_on = [aws_lb_target_group.front_end1-1]
  target_group_arn = aws_lb_target_group.front_end1-1[each.key].arn
  target_id = var.ftd02_outside_ip
}

#resource "aws_lb_target_group_attachment" "target1_2b" {
#  for_each = var.listener_ports
#  depends_on = [aws_lb_target_group.front_end1-2]
#  target_group_arn = aws_lb_target_group.front_end1-2[each.key].arn
#  target_id = var.ftd02_outside_ip
#}

#####################################################################
//optional -- Only required to map the target group to Internal LB.
###################################################################### 
#resource "aws_lb_target_group_attachment" "target2_1a" {
# for_each = var.listener_ports
# depends_on = [aws_lb_target_group.front_end2-1]
# target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# target_id = var.ftd01_inside_ip
#}
#resource "aws_lb_target_group_attachment" "target2_1b" {
# for_each = var.listener_ports
# depends_on = [aws_lb_target_group.front_end2-2]
# target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# target_id = var.ftd01_inside_ip
#}
//optional
#resource "aws_lb_target_group_attachment" "target2_2a" {
# for_each = var.listener_ports
# depends_on = [aws_lb_target_group.front_end2-1]
# target_group_arn = aws_lb_target_group.front_end2-1[each.key].arn
# target_id = var.ftd02_inside_ip
#}
#resource "aws_lb_target_group_attachment" "target2_2b" {
# for_each = var.listener_ports
# depends_on = [aws_lb_target_group.front_end2-2]
# target_group_arn = aws_lb_target_group.front_end2-2[each.key].arn
# target_id = var.ftd02_inside_ip
#}

##################################################################################################################################
#Output
##################################################################################################################################
output "ftd01ip" {
value = aws_eip.ftd01_mgmt-EIP.public_ip
}
output "ftd02ip" {
value = aws_eip.ftd02_mgmt-EIP.public_ip
}

output "FMCip" {
  value = aws_eip.fmcmgmt-EIP.public_ip
}
