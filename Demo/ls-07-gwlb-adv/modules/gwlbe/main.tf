# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "gwlbe_subnet" {
  count             = length(var.gwlbe_subnet_cidr) != 0 ? length(var.gwlbe_subnet_cidr) : 0
  vpc_id            = var.vpc_id
  cidr_block        = var.gwlbe_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.pod_prefix}-${var.gwlbe_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "gwlbe_route" {
  #count  = length(var.spoke_rt_id) != 0 ? length(var.spoke_rt_id) : 0
  count             = length(var.gwlbe_subnet_cidr) != 0 ? length(var.gwlbe_subnet_cidr) : 0
  vpc_id = var.vpc_id

   route {
     cidr_block = "0.0.0.0/0"
     nat_gateway_id =  var.nat_gw[count.index] #local.igw # modeule.nat_gw.ngw
   }

  tags = {
    Name = "${var.pod_prefix}-GWLB-RT-${count.index + 1}"
  }
}

# resource "aws_route" "gwlbe_ngw_route" {
#   count                  = length(var.spoke_subnet) != 0 ? (var.inbound ? 0 : length(var.spoke_subnet)) : 0
#   route_table_id         = aws_route_table.gwlbe_route[count.index].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = var.ngw_id[count.index]
# }

resource "aws_route" "gwlbe_igw_route" {
  count                  = length(var.spoke_subnet) != 0 ? (var.inbound ? length(var.spoke_subnet) : 0) : 0
  route_table_id         = aws_route_table.gwlbe_route[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway
}

resource "aws_route_table_association" "gwlbe_association" {
  #count          = length(var.spoke_rt_id) != 0 ? length(var.spoke_rt_id) : 0
  count          = length(var.gwlbe_subnet_cidr) != 0 ? length(var.gwlbe_subnet_cidr) : 0
  subnet_id      = length(var.gwlbe_subnet_cidr) != 0 ? aws_subnet.gwlbe_subnet[count.index].id : data.aws_subnet.gwlbe[count.index].id
  route_table_id = aws_route_table.gwlbe_route[count.index].id
}

resource "aws_vpc_endpoint_service" "glwbes" {
  acceptance_required        = false
  gateway_load_balancer_arns = [var.gwlb[0]]
}

resource "aws_vpc_endpoint" "gwlbe" {
  count             = length(var.gwlbe_subnet_cidr)
  service_name      = aws_vpc_endpoint_service.glwbes.service_name
  subnet_ids        = [aws_subnet.gwlbe_subnet[count.index].id]
  vpc_endpoint_type = aws_vpc_endpoint_service.glwbes.service_type
  vpc_id            = var.vpc_id
  tags = {
    Name = "${var.pod_prefix}-GWLBE-${count.index + 1}"
  }
}

resource "aws_route" "spoke_route" {
  count                  = length(var.spoke_rt_id) != 0 ? length(var.spoke_rt_id) : 0
  route_table_id         = var.spoke_rt_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id     = aws_vpc_endpoint.gwlbe[count.index].id
}

resource "aws_route_table" "igw_route" {
  depends_on = [
    aws_vpc_endpoint.gwlbe
  ]
  count             = var.inbound ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.pod_prefix}-INBOUND-RT-${count.index + 1}"
  }
}

resource "aws_route" "spoke_igw_route" {
  count                  = length(var.spoke_subnet) != 0 ? (var.inbound ? length(var.spoke_subnet) : 0) : 0
  route_table_id         = aws_route_table.igw_route[0].id
  destination_cidr_block = var.spoke_subnet[count.index]
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[count.index].id
}

resource "aws_route_table_association" "igw_rt" {
  count          = var.inbound ? 1 : 0
  gateway_id     = var.internet_gateway
  route_table_id = aws_route_table.igw_route[0].id
}
