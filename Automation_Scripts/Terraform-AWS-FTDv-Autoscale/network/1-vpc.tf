####################
# VPCs
####################

# Service VPC
resource "aws_vpc" "srvc_vpc" {
  cidr_block           = var.srvc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.env_name} Service VPC"
  }
}

# Service Subnets
resource "aws_subnet" "mgmt_subnet" {
  vpc_id            = aws_vpc.srvc_vpc.id
  cidr_block        = var.mgmt_subnet
  availability_zone = var.aws_az
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_name} Service Mgmt Subnet"
  }
}
resource "aws_subnet" "inside_subnet" {
  vpc_id            = aws_vpc.srvc_vpc.id
  cidr_block        = var.data_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "${var.env_name} Service Inside Subnet"
  }
}
resource "aws_subnet" "lambda_subnet" {
  vpc_id            = aws_vpc.srvc_vpc.id
  cidr_block        = var.lambda_subnet
  availability_zone = var.aws_az
  tags              = {
    Name = "${var.env_name} Lambda Subnet"
  }
}
resource "aws_subnet" "outside_subnet" {
  vpc_id            = aws_vpc.srvc_vpc.id
  cidr_block        = var.ccl_subnet
  availability_zone = var.aws_az
  tags              = {
    Name = "${var.env_name} Service Outside Subnet"
  }
}

# App VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.app_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.env_name } App VPC"
  }
}
# App Subnets
resource "aws_subnet" "gwlbe_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.gwlbe_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "${var.env_name } GWLBe Subnet"
  }
}
resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.app_subnet
  availability_zone = var.aws_az
  tags = {
    Name = "${var.env_name } App Subnet"
  }
}

####################
# VPC Endpoints
####################

# EC2 VPC Endpoint

resource "aws_vpc_endpoint" "ec2_ep" {
  vpc_id             = aws_vpc.srvc_vpc.id
  service_name       = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.lambda_subnet.id]
  security_group_ids = [
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "${var.env_name}-EC2-VPC-Endpoint"
  }
  private_dns_enabled = true
}

# Autoscaling VPC Endpoint

resource "aws_vpc_endpoint" "autoscale_ep" {
  vpc_id             = aws_vpc.srvc_vpc.id
  service_name       = "com.amazonaws.${var.region}.autoscaling"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.lambda_subnet.id]
  security_group_ids = [
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "${var.env_name}-AutoScaling-VPC-Endpoint"
  }
  private_dns_enabled = true
}

# ELB VPC Endpoint

resource "aws_vpc_endpoint" "elb_ep" {
  vpc_id             = aws_vpc.srvc_vpc.id
  service_name       = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.lambda_subnet.id]
  security_group_ids = [
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "${var.env_name}-ELB-VPC-Endpoint"
  }
  private_dns_enabled = true
}


# SNS VPC Endpoint

resource "aws_vpc_endpoint" "sns_ep" {
  vpc_id            = aws_vpc.srvc_vpc.id
  service_name      = "com.amazonaws.${var.region}.sns"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.lambda_subnet.id]
  security_group_ids = [
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "${var.env_name}-SNS-VPC-Endpoint"
  }
  private_dns_enabled = true
}


# Events VPC Endpoint

resource "aws_vpc_endpoint" "events_ep" {
  vpc_id             = aws_vpc.srvc_vpc.id
  service_name       = "com.amazonaws.${var.region}.events"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.lambda_subnet.id]
  security_group_ids = [
    aws_security_group.allow_all.id
  ]
  tags = {
    Name = "${var.env_name}-Events-VPC-Endpoint"
  }
  private_dns_enabled = true
}