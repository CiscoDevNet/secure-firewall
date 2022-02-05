#########################################################################################################################
# Locals
#########################################################################################################################

locals {
  existing_spoke_subnet = var.id_spoke_sub != [] ? true : false  
  spoke_subnet          = local.existing_spoke_subnet ? var.id_spoke_sub : [for subnet in aws_subnet.subnet_spoke_vpc : subnet.id]
}
#########################################################################################################################
# Data
#########################################################################################################################

data "aws_vpc" "service_vpc" {
  id = var.vpc_service_id
}

data "aws_vpc" "spoke_vpc" {
  id = var.vpc_spoke_id
}

###########################################################################################################################
# Resources 
###########################################################################################################################
# Subnets 
###########################################################################################################################

resource "aws_subnet" "subnet_service_vpc" {
  count = length(var.aws_availability_zones)
  vpc_id     = var.vpc_service_id
  cidr_block = var.cidr_service_sub[count.index]
  availability_zone = var.aws_availability_zones[count.index]
  tags = {
    Name = "${var.subnet_service_name}-${count.index + 1}"
  }
}

resource "aws_subnet" "subnet_spoke_vpc" {
  count      = local.existing_spoke_subnet ? 0 : length(var.cidr_spoke_sub)
  vpc_id     = var.vpc_spoke_id
  cidr_block = var.cidr_spoke_sub[count.index]

  tags = {
    Name = "${var.subnet_spoke_name}-${count.index + 1}"
  }
}

###########################################################################################################################
# Routes
###########################################################################################################################

resource "aws_route_table" "service_sub_rt" {
  count = length(var.aws_availability_zones)
  vpc_id = var.vpc_service_id

  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = var.gwlbe[count.index]
  }
  #route {
  #  cidr_block = data.aws_vpc.spoke_vpc.cidr_block
  #  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  #}
}

resource "aws_route_table_association" "attach_to_service_sub" {
  count          = length(var.cidr_service_sub)
  subnet_id      = aws_subnet.subnet_service_vpc[count.index].id
  route_table_id = aws_route_table.service_sub_rt[count.index].id
}

resource "aws_route_table" "spoke_sub_rt" {
  vpc_id = var.vpc_spoke_id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

resource "aws_route_table_association" "attach_to_spoke_sub" {
  for_each = toset([for id in local.spoke_subnet : id])
  subnet_id      = each.value
  route_table_id = aws_route_table.spoke_sub_rt.id
}

###########################################################################################################################
# Transit Gateway
###########################################################################################################################

resource "aws_ec2_transit_gateway" "tgw" {
    tags = {
      Name = var.transit_gateway_name
  }
}

###########################################################################################################################
# Transit Gateway Attachments
###########################################################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-service-vpc" {
  subnet_ids             = [for subnet in aws_subnet.subnet_service_vpc : subnet.id]
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
  vpc_id                 = var.vpc_service_id
  appliance_mode_support = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                    = {
    Name                  = "tgw-att-service-vpc"
  }
}  

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-spoke-vpc" {
  subnet_ids         = [for id in local.spoke_subnet : id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc_spoke_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags               = {
   Name              = "tgw-att-spoke-vpc"
  }
}  

###########################################################################################################################
# Routes
###########################################################################################################################

resource "aws_ec2_transit_gateway_route_table" "rt_service_vpc_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route_table" "rt_spoke_vpc_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_service_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-service-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_service_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_rt_assoc_spoke_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-spoke-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route" "default_rout_to_service_vpc" {
  destination_cidr_block         = data.aws_vpc.spoke_vpc.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-spoke-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_service_vpc_attach.id
}

resource "aws_ec2_transit_gateway_route" "default_rout_to_spoke_vpc" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-service-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_spoke_vpc_attach.id
}

##################################################################################################################################
#Additional Routes
##################################################################################################################################

resource "aws_route" "nat_route" {
  count                     = length(var.NAT_Subnet_Routetable_IDs)
  route_table_id            = var.NAT_Subnet_Routetable_IDs[count.index]
  destination_cidr_block    = data.aws_vpc.spoke_vpc.cidr_block
  vpc_endpoint_id           = var.gwlbe[count.index]
}

resource "aws_route" "gwlbe_route" {
  count                     = length(var.GWLBE_Subnet_Routetable_IDs)
  route_table_id            = var.GWLBE_Subnet_Routetable_IDs[count.index]
  destination_cidr_block    = data.aws_vpc.spoke_vpc.cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

##################################################################################################################################
#Output
##################################################################################################################################

output "tgw_id" {
    value = aws_ec2_transit_gateway.tgw.id
}