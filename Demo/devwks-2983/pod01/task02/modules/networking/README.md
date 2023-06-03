This is a module for [Cisco FMC in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html). 


## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## Use cases
This module will be used to configure all the network resources required for GCP. It also includes creation of subnets and firewall rules for our networks.

## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* network.tf: define VPC networks, custom routes.
* firewall.tf: define firewall rules.

## Inputs

Primarily all the input variables are to be changed from the terraform.tfvars files in examples only, these are described here just for convenience.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project where VPC networks will be created | string | - | yes |
| region | The region of the VPC networks will be created | string | - | yes |
| network| List of all network names,CIDR & Appliance IP | list| - | yes |
| appliance_ips (under network list)| internal IP address of the cisco appliances | string | "" | yes|
| appliance_ips_fmc| internal IP address of the FMCv | string | "" | yes|
| service_account| email of service account (fetched from service_acounts module) | string | "" | yes|
| mgmt_network|management network name | string | "" | yes|
| inside_network|intside network name | string | "" | yes|
| outside_network|outside network name | string | "" | yes|
| dmz_network|DMZ network name| string | "" | yes|
| diag_network|Diagnostic network name| string | "" | yes|
| custom_route_tag|Tag for route | string | "" | yes|

## Outputs

| Name | Description |
|------|-------------|
| networks_list | Network information to be used by VM Module |
| subnet_self_link_fmc| FMC subnet information to be used by VM Module|