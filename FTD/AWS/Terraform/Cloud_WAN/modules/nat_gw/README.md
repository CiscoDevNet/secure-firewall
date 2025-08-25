# Cisco Secure Firewall NAT Gateway module for AWS

Terraform Module to deploy 'n' number of NAT Gateways for outbound traffic in AWS

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

No Modules.

## Resources

| Name | Type |
|------|------|
| aws_subnet | resource |
| aws_route_table | resouce |
| aws_route_table_association | resource |
| aws_eip | resource |
| aws_nat_gateway | resource |
| aws_availability_zones | data source |
| aws_subnet | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ngw_subnet_cidr"></a> [ngw\_subnet\_cidr](#input\_ngw\_subnet\_cidr) | Specified ngw subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_name"></a> [ngw\_subnet\_name](#input\_ngw\_subnet\_name) | Specified ngw subnet name | `list(string)` | `[]` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Specified availablity zone count | `number` | `2` | no |
| <a name="input_vpc_id"></a> [vpc_id](#input\_vpc\_id) | Specified VPC ID | `string` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_rt_id"></a> [nat\_rt\_id](#output\_nat\_rt\_id) | NAT Gateway subnet Route table ID |
| <a name="output_ngw"></a> [ngw](#output\_ngw) | NAT Gateway ID |
