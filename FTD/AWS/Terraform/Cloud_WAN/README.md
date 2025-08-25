# Cloud WAN and Service Insertion

* AWS Cloud WAN is a managed wide-area networking (WAN) service that you can use to build, manage, and monitor a unified global network that connects resources running across your cloud and on-premises environments. "Service insertion" on Cloud WAN lets users easily insert third-party security services on Cloud WAN using a central Policy document.
* This Terraform script deploys the Inspection/Security VPC containing Cisco FTDv Firewalls to be attached to Network Function Group (NFG). 
* Creating Global network, Core Network, Creating and attaching Workload Segments to the Core Network, defining Policy for routing Segment traffic to the NFG for inspection, is done by the end-user.

## Pre-requisites

User should have the following components deployed- 
* AWS CWAN Core Network with Policy configured, Workload Segments attached with routing to the Core Network
* Cisco Firewall Management Center (FMC) 7.6+, reachable via Public IP and registered with a Smart License or Evaluation Mode enabled
* Terraform package installed on local machine - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## Deployment details

* This Terraform script deploys the Security VPC containing Gateway Load Balancer (GWLB), Internet-facing Elastic Load Balancer(ELB) and ‘N’ number of FTDv instances behind the GWLB.
* It registers the inside interfaces of FTDvs to the GWLB's target group, and outside interfaces to ELB's target group.
* On specifying FMC IP and credentials in terraform.tfvars, the script automatically registers the FTDvs to FMC, configures interfaces and static routes required.
* The solution supports the following Traffic flows:
    * Inter-segment and Intra-segment Traffic [via GWLB]
    * Egress Traffic [via GWLB]
    * Ingress Traffic [via ELB]   

## Steps to deploy the Security solution

* Git clone this repository to your local machine
* Navigate to directory `cloud-wan` within the cloned repository
* Set appropriate values for variables in terraform.tfvars as per your requirement. Specify region and credentials for your AWS account
* Run the following CLIs to deploy the solution using Terraform-
    * `terraform init`
    * `terraform apply`
* Press "Yes" to proceed; AWS Resources will begin to deploy
* Navigate to newly-created file `FTD_Mgmt_Public_IPs`, this contains Management Public IPs of the deployed FTDvs. On AWS, navigate to FMC's security group. Add rules to Allow Inbound traffic from these IPs. This is required for the FTDvs to register to FMC.
* Wait for the AWS Resources' deployment and FMC Configurations to complete.
* On completion, it is expected that all FTDvs have-
    * Booted up correctly, are registered to FMC, have an associated Access Policy
    * Interfaces management, diagnostic, inside, outside, VNI (proxy Dual-arm) configured and Security Zones associated
    * Static routes for interfaces inside, outside, VNI configured
    * NAT Rule configured for Egress traffic

## Manual Configurations to be done after Terraform Deploy is complete

* Create Platform Settings via FMC: Enable HTTP server on port 443 for FTDv's Inside and Outside interfaces, for replying to GWLB and ELB health checks respectively. Once done, verify from AWS UI that all targets in GWLB's and ELB's Target Group are Healthy
* Attach Security VPC to Core Network: On AWS UI, navigate to your Core Network -> Attachments. Attach Security VPC created by Terraform to your Core network's Network      Function Group (NFG). Select all the "core-network-attachment" subnets created across AZs for attaching to the Core Network. Enable "Appliance Mode" for this attachment.
Create appropriate Tags to map Core network's NFG to this VPC
* Set up routing between Security VPC, Core Network: On AWS UI, Add route [0.0.0.0/0 -> core-network-attachment] to the following Security VPC subnets across AZs:
    * GWLB-E subnet [for Inter-segment, Intra-segment, Egress cases]
    * Inside subnet [for Ingress case]
* [Ingress Case Only]: Configure NAT rule from FMC, to route Ingress traffic to Applications present in Workload Segments

## Notes & Limitations

* If you do not need Ingress traffic, you can delete ELB and its associated target group. Similarly,if you do not need Egress and Inter/Intra-segment traffic, you can delete GWLB and its associated target group
* If you want to perform the Firewall Management Center configuration manually (registration, interface configuration, static routes), comment out the FMC Configuration section in `cloud-wan/main.tf`.
* If you plan to upgrade/change the FTDv version using this script- Specify a newer version in `ftd_version` from terraform.tfvars, and perform the following:
    * `terraform destroy -target module.fmc_configuration`
    * `terraform apply`
    **Warning: This will replace the existing FTDvs with newer version FTDvs.**  Follow regular upgrade process through the FMC to avoid replacing FTDvs and erasing the configurations.
* This script does not support Cloud-delivered Firewall Management Center or local management via Firewall Device Manager.
* Resources deployed using this Terraform script cannot be orchestrated centrally via AWS CloudFormation or similar AWS services. All orchestration can be done via terraform CLIs only.
* If you face this error `Provider registry.terraform.io/hashicorp/template vX.X.X does not have a package available for your current platform` while running the terraform code, please use this solution to fix the problem: https://discuss.hashicorp.com/t/template-v2-2-0-does-not-have-a-package-available-mac-m1/35099/7
* As FTDv 7.8 is not GA, in order to deploy FTDv 7.8 please edit the product code in `modules/firewall_instance/data.tf: data.aws_ami.ftdv` as per the AMI you have access to.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |
| <a name="requirement_fmc"></a> [fmc](#requirement\_fmc) | <= 1.5.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_wan_attachment"></a> [cloud\_wan\_attachment](#module\_cloud\_wan\_attachment) | ../modules/cloudwan | n/a |
| <a name="module_external_load_balancer"></a> [external\_load\_balancer](#module\_external\_load\_balancer) | ../modules/load_balancer | n/a |
| <a name="module_fmc_configuration"></a> [fmc\_configuration](#module\_fmc\_configuration) | ../modules/fmc_config | n/a |
| <a name="module_gwlb"></a> [gwlb](#module\_gwlb) | ../modules/gwlb | n/a |
| <a name="module_gwlbe"></a> [gwlbe](#module\_gwlbe) | ../modules/gwlbe | n/a |
| <a name="module_instance"></a> [instance](#module\_instance) | ../modules/firewall_instance | n/a |
| <a name="module_service_network"></a> [service\_network](#module\_service\_network) | ../modules/network | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.FTD_Mgmt_Public_IPs](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [time_sleep.wait_for_ftd_initialization](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Specify availablity zone count. | `number` | `2` | no |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS ACCESS KEY | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS SECRET KEY | `string` | n/a | yes |
| <a name="input_byol"></a> [byol](#input\_byol) | If true, deploys FTDv with Bring Your Own License Image. If false, deploys FTDv with Pay As You Go Image. | `bool` | `true` | no |
| <a name="input_fmc_insecure_skip_verify"></a> [fmc\_insecure\_skip\_verify](#input\_fmc\_insecure\_skip\_verify) | Condition to verify FMC certificate | `bool` | `true` | no |
| <a name="input_fmc_mgmt_ip"></a> [fmc\_mgmt\_ip](#input\_fmc\_mgmt\_ip) | IP of you FMC | `string` | n/a | yes |
| <a name="input_fmc_nat_id"></a> [fmc\_nat\_id](#input\_fmc\_nat\_id) | FMC Registration NAT ID | `string` | `"cisco"` | no |
| <a name="input_fmc_password"></a> [fmc\_password](#input\_fmc\_password) | FMC admin password | `string` | n/a | yes |
| <a name="input_fmc_username"></a> [fmc\_username](#input\_fmc\_username) | FMC username | `string` | `"admin"` | no |
| <a name="input_ftd_admin_password"></a> [ftd\_admin\_password](#input\_ftd\_admin\_password) | Specify ftd admin password. | `string` | `""` | no |
| <a name="input_ftd_inside_gw"></a> [ftd\_inside\_gw](#input\_ftd\_inside\_gw) | Inside subnet Gateway | `list(string)` | <pre>[<br/>  "10.0.11.1",<br/>  "10.0.12.1"<br/>]</pre> | no |
| <a name="input_ftd_outside_gw"></a> [ftd\_outside\_gw](#input\_ftd\_outside\_gw) | Outside subnet Gateway | `list(string)` | <pre>[<br/>  "10.0.21.1",<br/>  "10.0.22.1"<br/>]</pre> | no |
| <a name="input_ftd_size"></a> [ftd\_size](#input\_ftd\_size) | FTD Instance Size | `string` | `"c5.xlarge"` | no |
| <a name="input_ftd_version"></a> [ftd\_version](#input\_ftd\_version) | n/a | `string` | `"ftdv-7.6.0-41"` | no |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | name for Gateway loadbalancer | `string` | n/a | yes |
| <a name="input_gwlbe_subnet_cidr"></a> [gwlbe\_subnet\_cidr](#input\_gwlbe\_subnet\_cidr) | List out GWLBE Subnet CIDR. | `list(string)` | `[]` | no |
| <a name="input_gwlbe_subnet_name"></a> [gwlbe\_subnet\_name](#input\_gwlbe\_subnet\_name) | List out GWLBE Subnet names. | `list(string)` | `[]` | no |
| <a name="input_inside_interface_sg"></a> [inside\_interface\_sg](#input\_inside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br/>    from_port   = number<br/>    protocol    = string<br/>    to_port     = number<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Inside Interface SG",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_instances_per_az"></a> [instances\_per\_az](#input\_instances\_per\_az) | Specify no. of instance per az needed. | `number` | `1` | no |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | key to be used for the instances | `string` | n/a | yes |
| <a name="input_mgmt_interface_sg"></a> [mgmt\_interface\_sg](#input\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br/>    from_port   = number<br/>    protocol    = string<br/>    to_port     = number<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Mgmt Interface SG",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_ngw_subnet_cidr"></a> [ngw\_subnet\_cidr](#input\_ngw\_subnet\_cidr) | List out NGW Subnet CIDR. | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_name"></a> [ngw\_subnet\_name](#input\_ngw\_subnet\_name) | List out NGW Subnet names. | `list(string)` | `[]` | no |
| <a name="input_outside_interface_sg"></a> [outside\_interface\_sg](#input\_outside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br/>    from_port   = number<br/>    protocol    = string<br/>    to_port     = number<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Outside Interface SG",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_performance_tier"></a> [performance\_tier](#input\_performance\_tier) | FTDv Performance Tier | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to the resources created | `string` | `""` | no |
| <a name="input_reg_key"></a> [reg\_key](#input\_reg\_key) | FTD registration key | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS REGION | `string` | `"us-east-1"` | no |
| <a name="input_service_vpc_cidr"></a> [service\_vpc\_cidr](#input\_service\_vpc\_cidr) | Service VPC CIDR | `string` | `null` | no |
| <a name="input_service_vpc_name"></a> [service\_vpc\_name](#input\_service\_vpc\_name) | Service VPC Name | `string` | `null` | no |
| <a name="input_use_ftd_eip"></a> [use\_ftd\_eip](#input\_use\_ftd\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |
| <a name="input_wan_subnet_cidr"></a> [wan\_subnet\_cidr](#input\_wan\_subnet\_cidr) | List of Cloud WAN GW Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_wan_subnet_name"></a> [wan\_subnet\_name](#input\_wan\_subnet\_name) | List of name for wan Subnets | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ftd_private_ips"></a> [ftd\_private\_ips](#output\_ftd\_private\_ips) | Private IP address of the FTD instances |
| <a name="output_ftd_public_ips"></a> [ftd\_public\_ips](#output\_ftd\_public\_ips) | Public IP address of the FTD instances |