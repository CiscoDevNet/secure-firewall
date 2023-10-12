# Cisco Secure Firewall Transit Gateway module for AWS

Terraform Module to deploy a transit gateway to manage traffic to and from Cisco Secure Firewall in AWS

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| aws_subnet | resource |
| aws_route_table | resource |
| aws_route_table_association | resource |
| aws_route | resource |
| aws_ec2_transit_gateway | resource |
| aws_ec2_transit_gateway_vpc_attachment | resource |
| aws_ec2_transit_gateway_route_table | resource |
| aws_ec2_transit_gateway_route_table_association | resource |
| aws_ec2_transit_gateway_route | resource |
| aws_availability_zones | data source |
| aws_route_table | data source |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_service_id"></a> [vpc\_service\_id](#input\_vpc\_service\_id) | ID of the service VPC | `string` | n/a | yes |
| <a name="input_vpc_spoke_id"></a> [vpc\_spoke\_id](#input\_vpc\_spoke\_id) | ID of the spoke VPC | `string` | n/a | yes |
| <a name="input_spoke_subnet_id"></a> [spoke\_subnet\_id](#input\_spoke\_subnet\_id) | ID of the Spoke Subnet | `list(any)` | n/a | yes |
| <a name="input_tgw_subnet_name"></a> [tgw\_subnet\_name](#input\_tgw\_subnet\_name) | List of name for TGW Subnets | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_cidr"></a> [tgw\_subnet\_cidr](#input\_tgw\_subnet\_cidr) | List of Transit GW Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_vpc_spoke_cidr"></a> [vpc\_spoke\_cidr](#input\_vpc\_spoke\_cidr) | Spoke VPC Subnet CIDR | `string` | n/a | yes |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="input_gwlbe"></a> [gwlbe](#input\_gwlbe) | ID of the GWLB Endpoints | `list(string)` | n/a | yes |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | Name of the Transit Gateway created | `string` | `null` | no |
| <a name="input_nat_subnet_routetable_ids"></a> [nat\_subnet\_routetable\_ids](#input\_nat\_subnet\_routetable\_ids) | list of Route table IDs associated with NAT Subnets | `list(string)` | `[]` | no |
| <a name="input_gwlbe_subnet_routetable_ids"></a> [gwlbe\_subnet\_routetable\_ids](#input\_gwlbe\_subnet\_routetable\_ids) | list of Route table IDs associated with GWLBE Subnets | `list(string)` | `[]` | no |
| <a name="input_spoke_rt_id"></a> [spoke\_rt\_id](#input\_spoke\_rt\_id) | Spoke VPC Route table ID | `list(string)` | n/a | yes |

## Outputs

No Outputs.