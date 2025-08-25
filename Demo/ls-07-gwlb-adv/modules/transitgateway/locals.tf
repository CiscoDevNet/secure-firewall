locals {
    tgw           = var.create_tgw ? aws_ec2_transit_gateway.tgw[0].id : data.aws_ec2_transit_gateway.tgw[0].id
    tgw_subnet    = length(var.tgw_subnet_cidr) != 0 ? aws_subnet.tgw_subnet.*.id : data.aws_subnet.tgw_subnet.*.id
    tgw_att_svc   = var.create_tgw ? aws_ec2_transit_gateway_vpc_attachment.tgw_att_service_vpc[0].id : data.aws_ec2_transit_gateway_vpc_attachment.tgw_att_service_vpc[0].id
    tgw_svc_rt    = var.create_tgw ? aws_ec2_transit_gateway_route_table.rt_service_vpc_attach[0].id : data.aws_ec2_transit_gateway_route_table.rt_service_vpc_attach[0].id
}