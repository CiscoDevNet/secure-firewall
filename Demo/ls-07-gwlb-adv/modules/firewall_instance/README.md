# Cisco Secure Firewall instance module for AWS

Terraform Module to deploy 'n' number of Cisco Secure FTD and FMC instances in AWS

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

No modules

## Resources

| Name | Type |
|------|------|
| aws_instance | resource |
| aws_ami | data source |
| template_file | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ftd_version"></a> [ftd\_version](#input\_ftd\_version_) | specified FTD version | `string` | ftdv-7.1.0 | no |
| <a name="input_create_fmc"></a> [create\_fmc](#input\_create\_fmc) | Boolean value to create FMC or not | `bool` | true | no |
| <a name="input_fmc_version"></a> [fmc_\_version](#input\_fmc\_version) | specified FMC version | `string` | n/a | yes |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | specified key pair name to connect firewall | `string` | n/a | yes |
| <a name="instances_per_az"></a> [instances\_per\_az] (#input\_instances\_per\_az) | Spacified no. of instance per az wants to be create | number | 1 | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="ftd_size"></a> [ftd\_size](#input\_ftd\_size) | specified server instance type | `string` | `c5.4xlarge` | no |
| <a name="input_fmc_mgmt_ip"></a> [fmc\_mgmt\_ip](#input\_fmc\_mgmt\_ip) | specified fmc management IPs | `string` | `""` | no |
| <a name="input_fmc_nat_id"></a> [fmc\_nat\_id](#input\_fmc\_nat\_id) | specified fmc nat id | `string` | `""` | no |
| <a name="input_ftd_mgmt_interface"></a> [ftd\_mgmt\_interface](#input\_ftd\_mgmt\_interface) | list out existing ENI IDs to be used for ftd management interface | `list(string)` | `[]` | no |
| <a name="input_ftd_inside_interface"></a> [ftd\_inside\_interface](#input\_ftd\_inside\_interface) | list out existing ENI IDs to be used for ftd inside interface | `list(string)` | `[]` | no |
| <a name="input_ftd_outside_interface"></a> [ftd\_outside\_interface](#input\_ftd\_outside\_interface) | list out existing ENI IDs to be used for ftd outside interface | `list(string)` | `[]` | no |
| <a name="input_ftd_diag_interface"></a> [ftd\_diag\_interface](#input\_ftd\_diag\_interface) | list out existing ENI IDs to be used for ftd diagnostic interface | `list(string)` | `[]` | no |
| <a name="input_fmcmgmt_interface"></a> [fmcmgmt\_interface](#input\_fmcmgmt\_interface) | list out existing ENI IDs to be used for ftd management interface | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | map the required tags | `map(any)` | `{}` | no |
| <a name="input_fmc_admin_password"></a> [fmc\_admin\_password](#input\_fmc\_admin\_password) | specified fmc admin password | `string` | `Cisco@123` | no |
| <a name="input_fmc_hostname"></a> [fmc\_hostname](#input\_fmc\_hostname) | specified fmc hostname | `string` | `FMC-01` | no |
| <a name="input_reg_key"></a> [fmc\_reg\_key](#input\_reg\_key) | specified reg key | `string` | `cisco` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | Public IP address of the EC2 instances |
| <a name="instance_private_ip"></a> [instance\_private_\_ip](#output\_instance\_private\_ip) | Private IP address of the EC2 instances |