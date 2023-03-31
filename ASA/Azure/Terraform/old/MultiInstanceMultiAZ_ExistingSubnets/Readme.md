# Terraform Template to create a Single or Multiple Instances of ASAv in Availability Zones at a location

## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Azure CLI – Learn how to download and set up [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

Make sure to login to Azure using below command to create any resources using Azure CLI:

```bash
az login --use-device-code
```

If you have multiple Subscriptions available, set default one using Subscription Name or Subscription ID:

```bash
az account set -s "MSDN Azure Subscription"
```

If this your first time of using ASAv instances on this Subscription, you have to read and accept the legal terms of the image first:
```bash
az vm image terms show --offer cisco-asav --plan asav-azure-byol --publisher cisco --query '{LicenseText:licenseTextLink, MarketplaceTerms:marketplaceTermsLink}'

az vm image terms accept --offer cisco-asav --plan asav-azure-byol --publisher cisco
```

The template has been tested on :
- Terraform = v1.0.1

## Overview

Using this Terraform template, `n` instances of ASAv will be deployed in Azure based on the user requirement, with the following components:

- Resource Group, Virtual Network and Subnets to be used should be provided by the user in the tfvars file.

- Public IP attachment to the management interface of each ASAv instance.
- One External and one Internal Load Balancer in case of more than one ASAv instance.

### Instances distribution

If there is more than `1` instance of ASAv, it will be distributed by Availability Zones (AZ) automatically. One can set preference for specific AZ in `azs` parameter.

*Please note, if there is more than `1` instance, yet only one AZ set in `azs` parameter - all instances will be placed in single AZ.*

### Parameters

The following variables should be defined with a value in the "terraform.tfvars" file before using the templates. 
*Please note, the value provided below and in .tfvars are just examples. Please change it based on your requirements.*

| Parameter | Meaning |
| --- | --- |
| `location = "eastus2` | Azure region |
| `prefix = "cisco-ASAv"` | Prefix to prepend resource names |
| `rg_name = "cisco-ASAv-RG"` | Azure Resource Group |
| `vn_name = "Cisco-ASAv-Vnet"` | Existing Virtual Network Name |
| `source_address = "*"` | Limit the Management access to specific source |
| `azs = ["1","2","3"]` | Azure Availability Zones |
| `instances = 2` | Number of ASAv instances |
| `vm_size = "Standard_D3_v2"` | Size of the VM for ASAv |
| `instancename = "ASAv"` | ASAv instance Name |
| `username = "cisco"` | Username for the VM OS |
| `password = "P@$$w0rd1234"` | Password for FMCvVM OS |
| `image_version = "917.0.3"` | Version of the ASAv |
| `management_subnet` | subnet name for management interface |
| `external_subnet` | subnet name for outside interface |
| `internal_subnet` | subnet name for inside interface |

## Deployment Procedure

1) Clone or Download the Repository 
2) Input the values in the terraform ".tfvars" for variables in .tf 
3) Initialize the providers and modules
     - go to the specific terraform folder from the cli 
        $ cd xxxx
        $ terraform init 
4) Submit the terraform plan 
    $ terraform plan -out <filename>
5) Verify the output of the plan in the terminal; if everything is fine, then apply the plan 
    $ terraform apply <out filename generated earlier>
6) Check the output and confirm it by typing "yes"

## Post Deployment Procedure

1) SSH to the instance by using ssh cisco@PublicIP

*Following configuration can be added as part of the template file ASA_Running_Config.txt or can be configured after accessing the device using SSH*</br>

2) configure each of the interface based on the subnet the interface belongs to

    An example is attached below,

    ```asa
        !
        interface GigabitEthernet0/0
        no shutdown
        nameif dmz
        security-level 50
        ip address dhcp
        !
        interface GigabitEthernet0/1
        no shutdown
        nameif outside
        security-level 100
        ip address dhcp
        !
    ```

3) Configure ACL to the outside interface

    ```asa
        access-list testacl extended permit ip any any
        access-group testacl in interface outside
        !
    ```

4) Configure the routes and enable ssh
  
    ```asa
        route outside 0.0.0.0 0.0.0.0 10.10.1.1 3
        route inside 10.10.4.0 255.255.255.0 10.10.2.1 3
        route outside 168.63.129.16 255.255.255.255 10.10.1.1 3
        route inside 168.63.129.16 255.255.255.255 10.10.2.1 4
        !
        ! For LB Probe status check
        ssh 0.0.0.0 0.0.0.0 outside
        ssh 0.0.0.0 0.0.0.0 inside
        !
    ```

*Note: The security group attached to the interfaces in this template allow traffic from anywhere. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports.*

ASAv are deployed in Availability Zones which provides a better fault tolerance