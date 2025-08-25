# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "gwlbe_subnet" {
  count             = length(local.gwlbe_subnet)
  vpc_id            = var.vpc_id
  cidr_block        = local.gwlbe_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-${local.gwlbe_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "gwlbe_route" {
  count  = length(local.gwlbe_subnet)
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.prefix}-GWLB-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "gwlbe_association" {
  count          = length(local.gwlbe_subnet)
  subnet_id      = aws_subnet.gwlbe_subnet[count.index].id
  route_table_id = aws_route_table.gwlbe_route[count.index].id
}

resource "aws_vpc_endpoint_service" "glwbes" {
  acceptance_required        = false
  gateway_load_balancer_arns = [var.gwlb[0]]
}

resource "aws_vpc_endpoint" "gwlbe" {
  count             = length(local.gwlbe_subnet)
  service_name      = aws_vpc_endpoint_service.glwbes.service_name
  subnet_ids        = [aws_subnet.gwlbe_subnet[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.glwbes.service_type
  vpc_id            = var.vpc_id
  tags = {
    Name = "${var.prefix}-GWLBE-${count.index + 1}"
  }
}


resource "aws_route_table" "igw_route" {
  depends_on = [
    aws_vpc_endpoint.gwlbe
  ]
  count  = var.inbound ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-INBOUND-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "igw_rt" {
  count          = var.inbound ? 1 : 0
  gateway_id     = var.internet_gateway
  route_table_id = aws_route_table.igw_route[0].id
}
