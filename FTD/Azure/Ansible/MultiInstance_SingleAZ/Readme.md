# Ansible Playbook Template to create Multiple Instances of FTDv and Single FMCv at a location

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

If this your first time of using FTDv instances on this Subscription, you have to read and accept the legal terms of the image first:
```bash
az vm image terms show --offer cisco-ftdv --plan ftdv-azure-byol --publisher cisco --query '{LicenseText:licenseTextLink, MarketplaceTerms:marketplaceTermsLink}'

az vm image terms accept --offer cisco-ftdv --plan ftdv-azure-byol --publisher cisco
```

Similarly, if this your first time of using a FMCv instance on this Subscription, you have to read and accept the legal terms of the image first:
```bash
az vm image terms show --offer cisco-fmcv --plan fmcv-azure-byol --publisher cisco --query '{LicenseText:licenseTextLink, MarketplaceTerms:marketplaceTermsLink}'

az vm image terms accept --offer cisco-fmcv --plan fmcv-azure-byol --publisher cisco
```

## Overview

Using this Ansible template, `n` instances of FTDv will be deployed along with an instance of FMCv optionally in Azure based on the user requirement, with the following components:

- One new Resource Group or an existing resource group can be used instead.
- One new Virtual Network or an existing Virtual Network with four subnets (1 Management networks, 2 data networks, 1 diagnostic) or existing Virtual Network can be used instead. New subnets will be created in both cases.
- Routing table attachment to each subnet.
- Public IP attachment to the management and outside interface of each FTDv instance as well as management interface of FMCv instance if created.

Subnet CIDR can be provided as input. If not provided, sequential address spaces will be used for subnets based on the subnet size provided.

### Parameters

The following variables should be defined with a value in the "vars.yaml" file before using the templates. 
*Please note, the value provided below and in vars.yaml are just examples. Please change it based on your requirements.*

| Parameter | Meaning |
| --- | --- |
| `location = "eastus` | Azure region |
| `prefix = "Cisco-SFW"` | Prefix to prepend resource names |
| `create_rg = true` | Wheather to create Resource Group |
| `rg_name = "SFW"` | Existing Azure Resource Group |
| `create_vn = true` | Wheather to create Virtual Network |
| `vn_name = "FTDv-VN"` | Existing Virtual Network Name |
| `vn_cidr = "10.0.0.0/16"` | Virtual Network CIDR |
| `subnet_size = 24` | Size of Subnets |
| `source_address = "*"` | Limit the Management access to specific source |
| `instances = 1` | Number of FTDv instances |
| `vm_size = "Standard_D3_v2"` | Size of the VM for FTDv |
| `instancename = "FTDv"` | FTDv instance Name |
| `username = "cisco"` | Username for the VM OS |
| `ftd_password = "P@$$w0rd1234"` | Password for FTD |
| `fmc_password = "P@$$w0rd1234"` | Password for FMC |
| `ftd_image_version = "73069.0.0"` | Version of the FTDv |
| `fmc_image_version = "73069.0.0"` | Version of the FTDv |
| `subnets = []` | CIDR for the subnets created |

## Deployment Procedure

1) Clone or Download the Repository 
2) Open the specific Ansible template directory and input the values in the "vars.yaml" for variables
3) In the same directory run the Ansible Playbook `deploy.yaml`
    $ ansible-playbook deploy.yaml

## Post Deployment Procedure

1) SSH to the instance by using ssh admin@PublicIP

Administrator will need to allow SSH on interface for Probe check and put in routes as described in the video for further testing : https://www.youtube.com/watch?v=Zjc9hmc2m68

*Note: The security group attached to the interfaces in this template allow traffic from anywhere. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports.*

2) If opted to create FMCv, Access the FMC GUI at https://PublicIPofFMC

*Note: It takes around 50-60 mins for the FMC GUI to get initialised and start working after deplyment.*

## Destruction Procedure

1) Open the same Ansible template directory and run the Ansible Playook `destroy.yaml`
    $ ansible-playbook destroy.yaml