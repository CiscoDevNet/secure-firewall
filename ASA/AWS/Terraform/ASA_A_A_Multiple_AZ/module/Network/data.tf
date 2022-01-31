data "aws_availability_zones" "available" {}

data "aws_subnet" "mgmt01" {
  count = var.mgmt01_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.mgmt01_subnet_name]
  }
}

data "aws_subnet" "mgmt02" {
  count = var.mgmt02_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.mgmt02_subnet_name]
  }
}

data "aws_subnet" "outsideasa01" {
  count = var.outside01_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.outside01_subnet_name]
  }
}

data "aws_subnet" "outsideasa02" {
  count = var.outside02_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.outside02_subnet_name]
  }
}

data "aws_subnet" "insideasa01" {
  count = var.inside01_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.inside01_subnet_name]
  }
}

data "aws_subnet" "insideasa02" {
  count = var.inside02_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.inside02_subnet_name]
  }
}

data "aws_subnet" "asa01dmz" {
  count = var.dmz01_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.dmz01_subnet_name]
  }
}

data "aws_subnet" "asa02dmz" {
  count = var.dmz02_subnet_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.dmz02_subnet_name]
  }
}

data "aws_vpc" "asa_vpc" {
  count = var.vpc_cidr == null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_internet_gateway" "default" {
  count = var.vpc_cidr == null ? 1 : 0
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.asa_vpc[0].id]
  }
}