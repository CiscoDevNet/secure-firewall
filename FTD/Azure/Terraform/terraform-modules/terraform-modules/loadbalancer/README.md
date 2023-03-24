<!-- BEGIN_TF_DOCS -->
# Create LoadBalancer module

## Overview

Create enternal and external LoadBalancer with spacified values

## Module Name
LoadBalancer

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="instances"></a> [instances](#instances) |Number of FTDv instances| `number` |`""`| yes |
| <a name="vn_name"></a> [vnet name](#vn_name) |  Existing Virtual Network Name | `string` |`""`| yes |
| <a name="rg_name"></a> [resource group name](#rg_name) |Azure Resource Group | `string` |`""`| yes |
| <a name="location"></a> [location](#location) |Spacify location | `string` |`""`| yes|
| <a name="subnet_id"></a> [subnet_id](#subnet_id) | spacified subnet id | `string` |10.0.0.0/16| yes |
| <a name="private_ip_address_ext"></a> [private_ip_address_ext](#private_ip_address_ext) |External Private ip address to assign to frontend. Use it with type = private | `list` | `""` | yes|
| <a name="private_ip_address_int"></a> [private_ip_address_int](#private_ip_address_int) |internal Private ip address to assign to frontend. Use it with type = private | `list` | `""` | yes|
| <a name="virtual_network_id"></a> [virtual_network_id"](#virtual_network_id") |Spacified Vnet ID | `string` | `""` | yes|
| <a name="get_private_ip_address"></a> [get_private_ip_address](#get_private_ip_address) |get_private_ip_address | `string` | `""` | yes|

<!-- END_TF_DOCS -->