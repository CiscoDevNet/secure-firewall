data "aws_availability_zones" "available" {}

data "aws_subnet" "mgmt" {
  count = var.mgmt_subnet_cidr == [] ? length(var.mgmt_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.mgmt_subnet_name[count.index]]
  }
}

data "aws_subnet" "outsideftd" {
  count = var.outside_subnet_cidr == [] ? length(var.outside_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.outside_subnet_name[count.index]]
  }
}

data "aws_subnet" "insideftd" {
  count = var.inside_subnet_cidr == [] ? length(var.inside_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.inside_subnet_name[count.index]]
  }
}

data "aws_subnet" "diagftd" {
  count = var.diag_subnet_cidr == [] ? length(var.diag_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.diag_subnet_name[count.index]]
  }
}

data "aws_vpc" "asa_vpc" {
  count = var.vpc_cidr == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_internet_gateway" "default" {
  count = var.create_igw ? 0 : 1
  filter {
    name   = "attachment.vpc-id"
    values = [local.con]
  }
}