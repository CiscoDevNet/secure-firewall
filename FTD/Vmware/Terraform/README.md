# Terraform Template to create a single Instance of FTDv in VMware

## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Vsphere credentials that will be used by Terraform to create the instance.


The template has been tested on :
- Terraform = v1.0.3

## Overview

Using this Terraform template a single instances of FTDv will be deployed in VMware. The FTDv instance will have four network interfaces attached to it.
Required day0 configuration values for FTDv can be added as variables. The available configurable options are mentioned in the variables sections.

### Variables

The following variables should be defined with a value in the "terraform.tfvars" file before using the templates. 

| Parameter | Meaning |
| --- | --- |
| `vsphere_server` | vsphere server connecting to for configuration |
| `vsphere_user` | username for access to vsphere server |
| `vsphere_password` | password for access to vsphere server |
| `datacenter` | datacenter where instance will be deployed |
| `datastore` | datastore used in deployment |
| `cpu = "4"` | FTDv number of CPU allocation |
| `memory = "8192"` | FTDv memory allocation |
| `network_name1` | Virtual Network Name for network interface 1 |
| `network_name2` | Virtual Network Name for network interface 2 |
| `network_name3` | Virtual Network Name for network interface 3 |
| `network_name4` | Virtual Network Name for network interface 4 |
| `resource_pool` | resource pool where instance will be deployed |
| `host` | host where instance will be deployed |
| `password` | admin user password |
| `hostname` | FTDv hostname |
| `dns1` | Primary DNS Server |
| `dns2` | Secondary DNS Server |
| `dns3` | Tertiary DNS Server |
| `searchdomains` | DNS Search Domains |
| `mgmt_ip4_config = "Manual"` | Management IPv4 Configuration |
| `mgmt_ip4` | Management IPv4 Address |
| `mgmt_ip4_mask` | Management IPv4 Mask |
| `mgmt_ip4_gateway` | Management IPv4 Gateway |
| `mgmt_ip6_config = "Disabled` | Management IPv6 Configuration | 
| `mgmt_ip6` | Management IPv6 Addres  |
| `mgmt_ip6_mask` | Management IPv6 Mask |
| `mgmt_ip6_gateway` | Management IPv6 Gateway |
| `local_manger = "Yes` | Enabled Manager locally |
| `firewall_mode = "routed"` | Firewall Mode |
| `fmc_ip` | Managing FMC IP |
| `fmc_regkey` | FMC Registration key |
| `fmc_nat_id` | FMC NAT ID |



## Deployment Procedure

1) Clone or Download the Repository 
2) Input the values in the terraform.tfvars file for variables in variables.tf</br>
   *Note: VI OVF file for the selected FTD Version should be used in the template for deployment.*
4) Initialize the providers and modules
     - go to the specific terraform folder from the cli 
        $ cd xxxx
        $ terraform init 
4) Submit the terraform plan 
    $ terraform plan -out <filename>
5) Verify the output of the plan in the terminal; if everything is fine, then apply the plan 
    $ terraform apply <out filename generated earlier>
6) Check the output and confirm it by typing "yes"

## Post Deployment Procedure

1) SSH to the instance by using ssh cisco@ManagementIP
