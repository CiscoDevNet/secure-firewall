# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_availability_zones" "available" {}

data "aws_route_table" "spoke_rt" {
  count          = length(var.spoke_rt_id)
  route_table_id = var.spoke_rt_id[count.index]
}
data "aws_route_table" "spoke_rt_2" {
  count          = length(var.spoke_rt_id_2)
  route_table_id = var.spoke_rt_id_2[count.index]
}

data "aws_subnet" "tgw_subnet" {
  count = length(var.tgw_subnet_cidr) == 0 ? length(var.tgw_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.tgw_subnet_name[count.index]]
  }
}

data "aws_ec2_transit_gateway" "tgw" {
  count = var.create_tgw ? 0 : 1
  filter {
    name   = "tag:Name"
    values = [var.transit_gateway_name]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_service_vpc" {
  count = var.create_tgw ? 0 : 1
  filter {
    name = "tag:Name"
    values = ["tgw-att-service-vpc"]
  }
}

data "aws_ec2_transit_gateway_route_table" "rt_service_vpc_attach" {
  count = var.create_tgw ? 0 : 1
  filter {
    name = "tag:Name"
    values = ["service vpc attachment RT"]
  }
}