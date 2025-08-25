# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_availability_zones" "available" {}
data "aws_subnet" "wan_subnet" {
  count = length(var.wan_subnet_cidr) == 0 ? length(var.wan_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.wan_subnet_name[count.index]]
  }
}

data "aws_ec2_transit_gateway" "wan" {
  count = var.create_wan ? 0 : 1
  filter {
    name   = "tag:Name"
    values = [var.transit_gateway_name]
  }
}

data "aws_ec2_transit_gateway_vpc_attachment" "wan_att_service_vpc" {
  count = var.create_wan ? 0 : 1
  filter {
    name   = "tag:Name"
    values = ["wan-att-service-vpc"]
  }
}

data "aws_ec2_transit_gateway_route_table" "rt_service_vpc_attach" {
  count = var.create_wan ? 0 : 1
  filter {
    name   = "tag:Name"
    values = ["service vpc attachment RT"]
  }
}