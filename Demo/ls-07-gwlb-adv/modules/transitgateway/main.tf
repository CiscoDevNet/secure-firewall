# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

resource "aws_subnet" "tgw_subnet" {
  count             = length(var.tgw_subnet_cidr) != 0 ? length(var.tgw_subnet_cidr) : 0
  vpc_id            = var.vpc_service_id
  cidr_block        = var.tgw_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.pod_prefix}-${var.tgw_subnet_name[count.index]}"
  }
}

resource "aws_route_table" "tgw_route" {
  count  = length(var.tgw_subnet_cidr) != 0 ? var.availability_zone_count : 0
  vpc_id = var.vpc_service_id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.gwlbe[count.index]
  }
}

resource "aws_route_table_association" "attach_to_service_sub" {
  count          = length(var.tgw_subnet_cidr) != 0 ? var.availability_zone_count : 0
  subnet_id      = local.tgw_subnet[count.index]
  route_table_id = aws_route_table.tgw_route[count.index].id
}

resource "aws_route" "spoke_route" {
  count                  = length(data.aws_route_table.spoke_rt)
  route_table_id         = data.aws_route_table.spoke_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = local.tgw
}

resource "aws_route" "spoke_route_2" {
  count                  = length(data.aws_route_table.spoke_rt_2)
  route_table_id         = data.aws_route_table.spoke_rt_2[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = local.tgw
}

###########################################################################################################################
# Transit Gateway
###########################################################################################################################

resource "aws_ec2_transit_gateway" "tgw" {
  count = var.create_tgw ? 1 : 0
  tags = {
    Name = "${var.pod_prefix}-${var.transit_gateway_name}"
  }
}

###########################################################################################################################
# Transit Gateway Attachments
###########################################################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_service_vpc" {
  count                                           = var.create_tgw ? 1 : 0
  subnet_ids                                      = local.tgw_subnet
  transit_gateway_id                              = local.tgw
  vpc_id                                          = var.vpc_service_id
  appliance_mode_support                          = var.tgw_appliance_mode
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.pod_prefix}-tgw-att-service-vpc"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_spoke_vpc" {
  subnet_ids                                      = var.spoke_subnet_id
  transit_gateway_id                              = local.tgw
  vpc_id                                          = var.vpc_spoke_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.pod_prefix}-tgw-att-a-vpc-${var.spoke_subnet_id[0]}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_spoke_vpc_2" {
  subnet_ids                                      = var.spoke_subnet_id_2
  transit_gateway_id                              = local.tgw
  vpc_id                                          = var.vpc_spoke_id_2
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.pod_prefix}-tgw-att-b-vpc--${var.spoke_subnet_id_2[0]}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_att_spoke_vpc_3" {
  subnet_ids                                      = var.spoke_subnet_id_3
  transit_gateway_id                              = local.tgw
  vpc_id                                          = var.vpc_spoke_id_3
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "${var.pod_prefix}-tgw-att-3rd-vpc--${var.spoke_subnet_id_3[0]}"
  }
}

###########################################################################################################################
# Routes
###########################################################################################################################

resource "aws_ec2_transit_gateway_route_table" "rt_service_vpc_attach" {
  count              = var.create_tgw ? 1 : 0
  transit_gateway_id = local.tgw
  tags = {
    Name = "${var.pod_prefix}-service vpc attachment RT"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rt_spoke_vpc_attach" {
  transit_gateway_id = local.tgw
  tags = {
    Name = "${var.pod_prefix}-vpc A attachment RT"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rt_spoke_vpc_attach_2" {
  transit_gateway_id = local.tgw
  tags = {
    Name = "${var.pod_prefix}-vpc B attachment RT"
  }
}
resource "aws_ec2_transit_gateway_route_table" "rt_spoke_vpc_attach_3" {
  transit_gateway_id = local.tgw
  tags = {
    Name = "${var.pod_prefix}-3rd Party attachment RT"
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_service_vpc" {
  count                          = var.create_tgw ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_service_vpc[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_service_vpc_attach[0].id
  
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_spoke_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id

}
resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_spoke_vpc_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_2.id

}
resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_spoke_vpc_3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_3.id

}
resource "aws_ec2_transit_gateway_route" "default_rout_to_service_vpc" {
  destination_cidr_block         = var.vpc_spoke_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc.id
  transit_gateway_route_table_id = local.tgw_svc_rt
}
resource "aws_ec2_transit_gateway_route" "default_rout_to_service_vpc_2" {
  destination_cidr_block         = var.vpc_spoke_cidr_2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_2.id
  transit_gateway_route_table_id = local.tgw_svc_rt
}
resource "aws_ec2_transit_gateway_route" "default_rout_to_service_vpc_3" {
  destination_cidr_block         = var.vpc_spoke_cidr_3
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_3.id
  transit_gateway_route_table_id = local.tgw_svc_rt
}
resource "aws_ec2_transit_gateway_route" "default_rout_to_spoke_vpc" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = local.tgw_att_svc
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route" "default_rout_to_spoke_vpc_2" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = local.tgw_att_svc
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_2.id
}
resource "aws_ec2_transit_gateway_route" "default_rout_to_spoke_vpc_3" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = local.tgw_att_svc
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_3.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_2.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc_3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_att_spoke_vpc_3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach_3.id
}

##################################################################################################################################
#Additional Routes
##################################################################################################################################

resource "aws_route" "nat_route" {
  count                  = length(var.nat_subnet_routetable_ids)
  route_table_id         = var.nat_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr
  vpc_endpoint_id        = var.gwlbe[count.index]
}

resource "aws_route" "gwlbe_route" {
  count                  = length(var.gwlbe_subnet_routetable_ids)
  route_table_id         = var.gwlbe_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr
  transit_gateway_id     = local.tgw
}
resource "aws_route" "gwlbe_route_2" {
  count                  = length(var.gwlbe_subnet_routetable_ids)
  route_table_id         = var.gwlbe_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr_2
  transit_gateway_id     = local.tgw
}
resource "aws_route" "gwlbe_route_3" {
  count                  = length(var.gwlbe_subnet_routetable_ids)
  route_table_id         = var.gwlbe_subnet_routetable_ids[count.index]
  destination_cidr_block = var.vpc_spoke_cidr_3
  transit_gateway_id     = local.tgw
}

