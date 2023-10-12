# Cisco Secure Firewall VPC Network module for AWS

Terraform Module to deploy VPC network infrastructure required for Cisco Secure Firewall deployment in AWS.

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
| aws_vpc | resource |
| aws_subnet | resource |
| aws_security_group | resource |
| aws_security_group_rule | resource |
| aws_network_interface | resource |
| aws_internet_gateway | resource |
| aws_route_table | resource |
| aws_route_table_association | resource |
| aws_eip | resource |
| aws_eip_association | resource |
| aws_availability_zones | data source |
| aws_subnet | data source |
| aws_vpc | data source |
| aws_internet_gateway | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Specified CIDR for VPC | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Specified VPC Name | `string` | `IAC-VPC` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Condition to create IGW . | `bool` | `false` | no |
| <a name="input_igw_name"></a> [igw\_name](#input\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Specified availablity zone count . | `number` | `2` | no |
| <a name="input_instances_per_az"></a> [instances\_per\_az](#input\_instances\_per\_az) | Spacified no. of instance per az wants to be create . | `number` | `1` | no |
| <a name="input_mgmt_subnet_cidr"></a> [mgmt\_subnet\_cidr](#input\_mgmt\_subnet\_cidr) | List out management Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ftd_mgmt_ip"></a> [ftd\_mgmt\_ip](#input\_ftd\_mgmt\_ip) | List out management IPs . | `list(string)` | `[]` | no |
| <a name="input_outside_subnet_cidr"></a> [outside\_subnet\_cidr](#input\_outside\_subnet\_cidr) | List out outside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ftd_outside_ip"></a> [ftd\_outside\_ip](#input\_ftd\_outside\_ip) | List outside IPs . | `list(string)` | `[]` | no |
| <a name="input_diag_subnet_cidr"></a> [diag\_subnet\_cidr](#input\_diag\_subnet\_cidr) | List out diagonastic Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ftd_diag_ip"></a> [ftd\_diag\_ip](#input\_ftd\_diag\_ip) | List out FTD Diagonostic IPs . | `list(string)` | `[]` | no |
| <a name="input_inside_subnet_cidr"></a> [inside\_subnet\_cidr](#input\_inside\_subnet\_cidr) | List out inside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ftd_inside_ip"></a> [ftd\_inside\_ip](#input\_ftd\_inside\_ip) | List FTD inside IPs . | `list(string)` | `[]` | no |
| <a name="input_fmc_ip"></a> [fmc\_ip](#input\_fmc\_ip) | List out FMCv IPs . | `string` | `""` | no |
| <a name="input_mgmt_subnet_name"></a> [mgmt\_subnet\_name](#input\_mgmt\_subnet\_name) | Specified management subnet names | `list(string)` | `[]` | no |
| <a name="input_outside_subnet_name"></a> [outside\_subnet\_name](#input\_outside\_subnet\_name) | Specified outside subnet names | `list(string)` | `[]` | no |
| <a name="input_inside_subnet_name"></a> [inside\_subnet\_name](#input\_inside\_subnet\_name) | Specified inside subnet names | `list(string)` | `[]` | no |
| <a name="input_diag_subnet_name"></a> [diag\_subnet\_name](#input\_diag\_subnet\_name) | Specified diagonstic subnet names | `list(string)` | `[]` | no |
| <a name="input_mgmt_interface"></a> [mgmt\_interface](#input\_mgmt\_interface) | list of management interface | `list(string)` | `[]` | no |
| <a name="input_outside_interface"></a> [outside\_interface](#input\_outside\_interface) | list of outside interface | `list(string)` | `[]` | no |
| <a name="input_inside_interface"></a> [inside\_interface](#input\_inside\_interface) | list of inside interface | `list(string)` | `[]` | no |
| <a name="input_diag_interface"></a> [diag\_interface](#input\_diag\_interface) | list of diagnostic interface | `list(string)` | `[]` | no |
| <a name="input_fmc_interface"></a> [fmc\_interface](#input\_fmc\_interface) | Specified FMCv interface | `string` | `""` | no |
| <a name="input_outside_interface_sg"></a> [outside\_interface\_sg](#input\_outside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_inside_interface_sg"></a> [inside\_interface\_sg](#input\_inside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_mgmt_interface_sg"></a> [mgmt\_interface\_sg](#input\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_fmc_mgmt_interface_sg"></a> [fmc\_mgmt\_interface\_sg](#input\_fmc\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_use_ftd_eip"></a> [use\_ftd\_eip](#input\_use\_ftd\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |
| <a name="input_use_fmc_eip"></a> [use\_fmc\_eip](#input\_use\_fmc\_eip) | boolean value to use EIP on FMC or not | `bool` | `false` | no |

Note: In this build using existing interface resources are not supported. New interfaces will be created.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_mgmt_interface"></a> [mgmt\_interface](#output\_mgmt\_interface) | Mgmt interface id |
| <a name="output_outside_interface"></a> [outside\_interface](#output\_outside\_interface) | Outside interface id |
| <a name="output_inside_interface"></a> [inside\_interface](#output\_inside\_interface) | Inside interface id |
| <a name="output_diag_interface"></a> [diag\_interface](#output\_diag\_interface) | Diagnostic interface id |
| <a name="output_fmcmgmt_interface"></a> [fmcmgmt\_interface](#output\_fmcmgmt\_interface) | FMC Mgmt interface id |
| <a name="output_mgmt_subnet"></a> [mgmt\_subnet](#output\_mgmt\_subnet) | Mgmt Subnet id |
| <a name="output_inside_subnet"></a> [inside\_subnet](#output\_inside\_subnet) | Inside Subnet id |
| <a name="output_outside_subnet"></a> [outside\_subnet](#output\_outside\_subnet) | Outside Subnet id |
| <a name="output_diag_subnet"></a> [diag\_subnet](#output\_diag\_subnet) | Diagnostic Subnet id |
| <a name="output_mgmt_interface_ip"></a> [mgmt\_interface\_ip](#output\_mgmt\_interface\_ip) | Mgmt Interface IP |
| <a name="output_inside_interface_ip"></a> [inside\_interface\_ip](#output\_inside\_interface\_ip) | Inside Interface IP |
| <a name="output_outside_interface_ip"></a> [outside\_interface\_ip](#output\_outside\_interface\_ip) | Outside Interface IP |
| <a name="output_diag_interface_ip"></a> [diag\_interface\_ip](#output\_diag\_interface\_ip) | Diagnostic Interface IP |
| <a name="output_fmc_interface_ip"></a> [fmc\_interface\_ip](#output\_fmc\_interface\_ip) | FMC Interface IP |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | Internet Gateway ID |
| <a name="output_mgmt_rt_id"></a> [mgmt\_rt\_id](#output\_mgmt\_rt\_id) | Mgmt subnet Route table ID |



