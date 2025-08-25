###################
# AWS Data
####################

# Service VPC
data "aws_vpc" "srvc_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service VPC"]
  }
}

# Service Subnets
data "aws_subnet" "mgmt_subnet" {
  vpc_id = data.aws_vpc.srvc_vpc.id
    filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service Mgmt Subnet"]
  }
}
data "aws_subnet" "inside_subnet" {
  vpc_id = data.aws_vpc.srvc_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service Inside Subnet"]
  }
}
data "aws_subnet" "lambda_subnet" {
  vpc_id = data.aws_vpc.srvc_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Lambda Subnet"]
  }
}
data "aws_subnet" "outside_subnet" {
  vpc_id = data.aws_vpc.srvc_vpc.id
    filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service Outside Subnet"]
  }
}

# App VPC
data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.env_name } App VPC"]
  }
}

# App Subnets
data "aws_subnet" "gwlbe_subnet" {
  vpc_id            = data.aws_vpc.app_vpc.id
    filter {
    name   = "tag:Name"
    values = ["${var.env_name } GWLBe Subnet"]
  }
}
data "aws_subnet" "app_subnet" {
  vpc_id            = data.aws_vpc.app_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name } App Subnet"]
  }
}

data "aws_network_interfaces" "inside_interfaces" {
  filter {
    name   = "subnet-id"
    values = [data.aws_subnet.inside_subnet.id]
  }
}


data "aws_network_interfaces" "outside_interfaces" {
  filter {
    name   = "subnet-id"
    values = [data.aws_subnet.outside_subnet.id]
  }
}

data "aws_security_group" "app_allow_all" {
  vpc_id = data.aws_vpc.app_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service SG"]
  }
}

data "aws_security_group" "allow_all" {
  vpc_id = data.aws_vpc.srvc_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service SG"]
  }
}

data "aws_security_group" "fmc_ftd_mgmt" {
  vpc_id = data.aws_vpc.srvc_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.env_name} Service Mgmt SG"]
  }
}

data "aws_internet_gateway" "mgmt_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.srvc_vpc.id]
  }
}

data "aws_lb" "gwlb" {
  name = "gwlb"
}

# FTD AMI Data

data "aws_ami" "ftdv" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["ftdv-7.2*"]
  }
  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }
}

###################
# FMC Data
####################

# Data Sources
data "fmc_port_objects" "http" {
    name = "HTTP"
}
data "fmc_port_objects" "https" {
    name = "HTTPS"
}
data "fmc_port_objects" "ssh" {
    name = "SSH"
}
data "fmc_ips_policies" "ips_base_policy" {
    name = "Security Over Connectivity"
}