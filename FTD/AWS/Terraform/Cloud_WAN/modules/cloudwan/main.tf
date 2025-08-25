# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "wan_subnet" {
  count             = length(local.wan_subnet)
  vpc_id            = var.vpc_service_id
  cidr_block        = local.wan_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.prefix}-${local.wan_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "wan_route" {
  count  = length(local.wan_subnet)
  vpc_id = var.vpc_service_id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.gwlbe[count.index]
  }
}

resource "aws_route_table_association" "attach_to_service_sub" {
  count          = length(local.wan_subnet)
  subnet_id      = aws_subnet.wan_subnet[count.index].id
  route_table_id = aws_route_table.wan_route[count.index].id
}
