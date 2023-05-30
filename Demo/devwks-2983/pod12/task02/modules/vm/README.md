This is a module for [Cisco FMC in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html). 


## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## Use cases
This module will be used to configure create our virtual machine instances for FTDv & FMCv.

## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* Template folder has day0 configuration files for FTDv and FMCv.

## Inputs

Primarily all the input variables are to be changed from the terraform.tfvars files in examples only, these are described here just for convenience.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The ID of the project where VPC networks will be created | string | - | yes |
| region | The region of the VPC networks will be created | string | - | yes |
| network| List of all network names,CIDR & Appliance IP | list| - | yes |
| appliance_ips (under network list)| internal IP address of the cisco appliances | string | "" | yes|
| appliance_ips_fmc| internal IP address of the FMCv | string | "" | yes|
| num_instances | Number of instances to create | number | 1 | yes |
| vm_machine_type | The machine type of the instance | string | "e2-standard-4" | yes |
| fmc_hostname |  FMC hostname | string | fmc | no |
| ftd_hostname |  FTD hostname | string | ftd | no |
| vm\_instance\_labels | Labels to apply to the vm instances. | `map(string)` | `{}` | no |
| boot_disk_size | boot disk size in GB | string | 250 | no |
| boot_disk_type | boot disk type | string | pd-ssd | no |
| cisco_product_version | product version of cisco appliance | string| "cisco-ftdv-7-3-0-69" | no |
| day_0_config | The zero day configuration file name, under templates folder|string| - | no |
| admin_password | fmc admin password | string | - | no | 
| admin_ssh_pub_key| ssh public key for admin user | string| - | Yes |

## Outputs

| Name | Description |
|------|-------------|
| FMC_Public_IP | The external IP of FMC |
| FTD_Public_IP| The external IPs of FTDs|
| instance_ids| IDs of instances|
