# Cisco Secure Firewall Gateway loadbalancer endpoint module for AWS

Terraform Module to deploy 'n' number of subnets for gateway loadbalancer endpoint with a default route to the provided NAT gateway ID in case of outboud traffic and 'n' number of gateway loadbalancer endpoints. Where 'n' is number of spoke subnets

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

| Name | Version |
|------|---------|
| aws_subnet | resource |
| aws_route_table | resource |
| aws_route_table_association | resource |
| aws_vpc_endpoint_service | resource |
| aws_vpc_endpoint | resource |
| aws_availability_zones | data source |
| aws_subnet | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gwlbe_subnet_cidr"></a> [gwlbe\_subnet\_cidr](#input\_gwlbe\_subnet\_cidr) | GWLB-Endpoint subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_gwlbe_subnet_name"></a> [gwlbe\_subnet\_name](#input\_gwlbe\_subnet\_name) | GWLB-Endpoint subnet name | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the service VPC | `string` | n/a | yes |
| <a name="input_ngw_id"></a> [ngw_id](#input\_ngw\_id) | NAT GW Subnet ID | `list(string)` | n/a | yes |
| <a name="input_gwlb"></a> [gwlb](#input\_gwlb) | Gateway Loadbalancer arn | `list(string)` | n/a | yes |
| <a name="input_igw_id"></a> [igw_id](#input\_igw_id) | Internet Gateway ID | `string` | n/a | no |
| <a name="input_spoke_rt_id"></a> [spoke_rt_id](#input\_spoke_rt_id) | Route table ID of spoke subnet for distributed architecture | `list(string)` | n/a | no |
| <a name="input_inbound"></a> [inbound](#input\_inbound) | Condition to determine inbound or outbound traffic | `bool` | false | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gwlbe_rt_id"></a> [gwlbe\_rt\_id](#output\_gwlbe\_rt\_id) | Gateway loadbalancer Endpoint subnet route table ID |
| <a name="output_gwlb_endpoint_id"></a> [gwlb\_endpoint\_id](#output\_gwlb\_endpoint\_id) | gwlb vpc endpoint |