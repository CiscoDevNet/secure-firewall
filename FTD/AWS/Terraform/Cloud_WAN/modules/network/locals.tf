# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

locals {
  instances = var.availability_zone_count * var.instances_per_az
  #   mgmt_subnet    = cidrsubnets("10.0.1.0/21", [for i in range(var.availability_zone_count) : 4]...)
  #   inside_subnet  = cidrsubnets("10.0.10.0/21", [for i in range(var.availability_zone_count) : 4]...)
  #   outside_subnet = cidrsubnets("10.0.20.0/21", [for i in range(var.availability_zone_count) : 4]...)
  #   diag_subnet    = cidrsubnets("10.0.30.0/21", [for i in range(var.availability_zone_count) : 4]...)
  #   
  mgmt_subnet         = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.vpc_cidr), 0, 2))}.${i + 1}.0/24"]
  inside_subnet       = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.vpc_cidr), 0, 2))}.${10 + i + 1}.0/24"]
  outside_subnet      = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.vpc_cidr), 0, 2))}.${20 + i + 1}.0/24"]
  diag_subnet         = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.vpc_cidr), 0, 2))}.${30 + i + 1}.0/24"]
  mgmt_subnet_name    = [for i in range(var.availability_zone_count) : "mgmt_subnet${i + 1}"]
  inside_subnet_name  = [for i in range(var.availability_zone_count) : "inside_subnet${i + 1}"]
  outside_subnet_name = [for i in range(var.availability_zone_count) : "outside_subnet${i + 1}"]
  diag_subnet_name    = [for i in range(var.availability_zone_count) : "diag_subnet${i + 1}"]
  azs                 = chunklist(sort(flatten(chunklist(setproduct(range(local.instances), range(1, (var.availability_zone_count + 1))), local.instances)[0])), local.instances)[1]
}
