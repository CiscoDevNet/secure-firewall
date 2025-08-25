# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_availability_zones" "available" {}

data "aws_subnet" "mgmt" {
  count = length(var.mgmt_subnet_cidr) == 0 ? length(var.mgmt_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.mgmt_subnet_name[count.index]]
  }
}

data "aws_subnet" "outsideftd" {
  count = length(var.outside_subnet_cidr) == 0 ? length(var.outside_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.outside_subnet_name[count.index]]
  }
}

data "aws_subnet" "insideftd" {
  count = length(var.inside_subnet_cidr) == 0 ? length(var.inside_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.inside_subnet_name[count.index]]
  }
}

data "aws_subnet" "diagftd" {
  count = length(var.diag_subnet_cidr) == 0 ? length(var.diag_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.diag_subnet_name[count.index]]
  }
}

data "aws_vpc" "ftd_vpc" {
  count = var.vpc_cidr == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# data "aws_internet_gateway" "default" {
#   count = var.create_igw ? 0 : var.igw_name == "" ? 0 : 1
#   filter {
#     name   = "attachment.vpc-id"
#     values = [local.con]
#   }
# }

data "aws_vpc" "spoke_vpc" {
  count = var.vpc_cidr == "" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}