# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

data "aws_availability_zones" "available" {}

# data "aws_subnet" "dngw_subnet" {
#   depends_on = [aws_subnet.ngw_subnet]
#   count      = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : 0
#   filter {
#     name   = "tag:Name"
#     values = [var.ngw_subnet_name[count.index]]
#   }
# }

# data "aws_subnet" "ngw" {
#   count = length(var.ngw_subnet_cidr) == 0 ? length(var.ngw_subnet_name) : 0
#   filter {
#     name   = "tag:Name"
#     values = [var.ngw_subnet_name[count.index]]
#   }
# }