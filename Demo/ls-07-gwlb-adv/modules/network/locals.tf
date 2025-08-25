# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

locals {
  con            = var.vpc_cidr != "" ? aws_vpc.ftd_vpc[0].id : data.aws_vpc.ftd_vpc[0].id
  instances      = var.availability_zone_count * var.instances_per_az
  mgmt_subnet    = length(var.mgmt_subnet_cidr) != 0 ? aws_subnet.mgmt_subnet : data.aws_subnet.mgmt
  inside_subnet  = length(var.inside_subnet_cidr) != 0 ? aws_subnet.inside_subnet : data.aws_subnet.insideftd
  outside_subnet = length(var.outside_subnet_cidr) != 0 ? aws_subnet.outside_subnet : data.aws_subnet.outsideftd
  diag_subnet    = length(var.diag_subnet_cidr) != 0 ? aws_subnet.diag_subnet : data.aws_subnet.diagftd
  azs            = chunklist(sort(flatten(chunklist(setproduct(range(local.instances), range(1, (var.availability_zone_count + 1))), local.instances)[0])), local.instances)[1]
  igw            = var.create_igw ? aws_internet_gateway.int_gw[0].id : null
  # igw            = var.create_igw ? aws_internet_gateway.int_gw[0].id : data.aws_internet_gateway.default[0].id
}
