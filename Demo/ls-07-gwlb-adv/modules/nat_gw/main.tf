# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "ngw_subnet" {
  count             = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : 0
  vpc_id            = var.vpc_id
  cidr_block        = var.ngw_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.pod_prefix}-${var.ngw_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "ngw_route" {
  count  = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : length(var.ngw_subnet_name)
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway
  }
  tags = {
    Name = "${var.pod_prefix}-nat gw network Routing table"
  }
}

resource "aws_route_table_association" "ngw_association" {
  count          = length(var.ngw_subnet_cidr) != 0 ? length(var.ngw_subnet_cidr) : length(var.ngw_subnet_name)
  subnet_id      = aws_subnet.ngw_subnet[count.index].id
  route_table_id = aws_route_table.ngw_route[count.index].id
}

resource "aws_route" "vpce_route" {
  count                  = length(var.spoke_subnet_cidr) != 0 ? 1 : 0
  route_table_id         = aws_route_table.ngw_route[count.index].id
  destination_cidr_block = var.spoke_subnet_cidr[count.index]
  vpc_endpoint_id        = var.gwlb_endpoint_id[count.index]
}

resource "aws_eip" "nat_eip" {
  count = var.availability_zone_count
}

resource "aws_nat_gateway" "natgw" {
  depends_on    = [aws_subnet.ngw_subnet]
  count         = var.availability_zone_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.ngw_subnet[count.index].id

  tags = {
    Name = "${var.pod_prefix}-NAT-GW-${count.index + 1}"
  }
}