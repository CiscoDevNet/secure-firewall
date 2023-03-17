<!-- BEGIN_TF_DOCS -->
# Create Network module

## Overview

Create Network resource like Vnet, subnet, network interface card, network security group,routetable,public ip

## Module Name
network

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="create_vn"></a> [create_vn](#create_vn) |Whether to create Virtual Network| `boolean` |`""`| yes |
| <a name="vn_name"></a> [vnet name](#vn_name) |  Existing Virtual Network Name | `string` |`""`| yes |
| <a name="rg_name"></a> [resource group name](#rg_name) |Azure Resource Group | `string` |`""`| yes |
| <a name="location"></a> [location](#location) |Specify location | `string` |`""`| yes|
| <a name="vn_cidr"></a> [vnet cidr](#vn_cidr) | Virtual Network CIDR | `string` |10.0.0.0/16| yes |
| <a name="tags"></a> [tags](#tags) |Specify tags name for the resources | `map(string)` | `""` | yes|
| <a name="subnet list"></a> [subnet_lists](#subnet_lists) |Add list of subnet list  | `list` | `""` | yes|
| <a name="address prefixes"></a> [address_prefixes](#address_prefixes) |specify address prefixes of subnets | `list` | `""` | yes|
| <a name="network security group"></a> [NSG](#NSG) |specify NGS inbound and outbond rule | `string` | `""` | yes|
| <a name="route table"></a> [routetable](#routetable) |add routetable associate with subnets | `string` | `""` | yes|
| <a name="network interface"></a> [network interface](#networkinterface) |network interface attached with subnets | `list` | `""` | yes|

## Outputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="mgmt_interface"></a> [mgmt_interface](#mgmt_interface) |Management interface id| `string` |`""`| yes |
| <a name="outside_interface"></a> [outside_interface](#outside_interface) |Outside interface id| `string` |`""`| yes |
| <a name="outside_interface_ip_address"></a> [outside_interface_ip_address](#outside_interface_ip_address) |Outside interface ip address| `string` |`""`| yes |
| <a name="inside_interface"></a> [inside_interface](#inside_interface) |Inside interface id| `string` |`""`| yes |
| <a name="inside_interface_ip_address"></a> [inside_interface_ip_address](#inside_interface_ip_address) |Inside interface ip address| `string` |`""`| yes |
| <a name="diag_interface"></a> [diag_interface](#diag_interface) |Diag interface id| `string` |`""`| yes |
| <a name="inside_subnet"></a> [inside_subnet](#inside_subnet) |Inside subnet id| `string` |`""`| yes |
| <a name="inside_subnet_cidr"></a> [inside_subnet_cidr](#inside_subnet_cidr) |Inside subnet CIDR| `string` |`""`| yes |
| <a name="virtual_network_id"></a> [virtual_network_id](#virtual_network_id) |Virtual network id| `string` |`""`| yes |

<!-- END_TF_DOCS -->