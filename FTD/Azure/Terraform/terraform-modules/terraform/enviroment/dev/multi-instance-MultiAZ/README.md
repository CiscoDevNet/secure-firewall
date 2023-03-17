<!-- BEGIN_TF_DOCS -->
# Deployment of Cisco Secure FTDv instances in Azure

## Overview

Using this Terraform template, two instance of FTDv will be deployed in  Azure in a new Vnet with the following components, 

- one new Vnet with four network interfaces (1 Management networks, 3 data networks)
- Routing table attachment to each of these subnets. 

## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Programmatic access to Azure account with CLI - learn how to set up [here](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.1.9 |
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 2.53.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 2.53.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource group](#module\_instance) | ../../../../terraform-modules/rg | n/a |
| <a name="module_service_network"></a> [network](#module\_service\_network) | ../../../../terraform-modules/network | n/a |
| <a name="module_firewall_server"></a> [firewall](#module\_service\_network) | ../../../../terraform-modules/firewallserver | n/a |
| <a name="loadbancer"></a> [loadbalancer](#module\_service\_loadbalncer) | ../../../../terraform-modules/loadbalancer | n/a |

## Resources

Provisioning of FTDv servers in Multi AZs

## Firewall Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="subscription_id"></a> [subscription\_id](#input\_subscription\_id) | subscription_id | `string` | n/a | yes |
| <a name="tenant_id"></a> [tenant\_id](#input\_tenant\_id) | tenant_id | `string` | n/a | yes |
| <a name="client_id"></a> [client\_id](#input\_client\_id) | client_id | `string` | n/a | yes |
| <a name="client_secret"></a> [client\_secret](#input\client\_secret) |client\_secret | `string` | n/a | yes |
| <a name="resource_group"></a> [resource\_resource](#input\_resource\_group) | list of resource group| `list(string)` | `[]` | yes |
| <a name="location"></a> [location](#location) | Specify location | `string` |  n/a | yes |
| <a name="instances"></a> [instances](#instances) |Spacify no. of instances | `number` | `""` | yes|
| <a name="subnet id"></a> [subnet_id](#subnetid) |Spacify subnet id for internal loadbancer | `string` | `""` | yes|
| <a name="private id address for frontend_ip_configuration"></a> [private_ip_address](#privateipaddesss) |private id address for frontend_ip_configuration for internal loadbancer | `string` | `""` | yes|
| <a name="private id address for internal lb"></a> [private_ip_address](#privateipaddesss) |private id address for internal lb | `string` | `""` | yes|
| <a name="private id address for external lb"></a> [private_ip_address](#privateipaddesss) |private id address for external lb | `string` | `""` | yes|
| <a name="virtual network id"></a> [virtual_network_id ](#virtualnetworkid) |virtual network id  for backend address pool for internal loadbancer | `string` | `""` | yes|

<!-- END_TF_DOCS -->