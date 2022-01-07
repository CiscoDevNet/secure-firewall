### Terraform Template for Installation of a Single Instance of FTDv on Azure

![Topology](AzureSingleInstanceFTD.png)

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

The template has been tested on :

- Terraform Version =  1.0.1
- Hashicorp AzureRM Provider = 2.53.0

Using this Terraform template, one instance of FTD will be deployed in Azure based on the user requirement.

- one new VPC with four subnets (1 Management networks, 3 data networks)
- Routing table attachment to each of these subnets.
- Public IP attachment to Management and Outside interfaces of the FTDv instance.

The variables should be defined with a value in the "terraform. tfvars" file before using the templates. If no values are provided the default values will be used.

### Variables

| Variable | Meaning |
| --- | --- |
| `location = "centraleurope"` | Resorce group Location in Azure |
| `prefix = "cisco-ftdv"` | This would prefix all the component with this string |
| `source-address = "*"` | Limit the Management access to specific source IPs |
| `IPAddressPrefix = "10.10"` | All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet and subnet mask as /24 |
| `Version = "67065.0.0"` | FTD Version to be deployed - Please validate the correct version using - `az vm image list --offer ftdv --all` |
| `VMSize = "Standard_D3_v2"` | Size of the FTDv to be deployed |
| `RGName = "cisco-ftdv-RG"` | Resource Group Name |
| `instancename = "cisco-ftdv"` | Instance Name and properties of FTDv |
| `username = "cisco"` | Username to login to FTD |
| `password = "P@$$w0rd1234"` | Password to login to FTD |

## Deployment Procedure

1) Clone or Download the Repository
2) Input the values in the terraform ".tfvars" for variables in .tf
3) Initialize the providers and modules

    ```ftd
     - go to the specific terraform folder from the cli 
        cd xxxx
        terraform init 
    ```

4) submit the terraform plan

    ```ftd
       terraform plan -out <filename>
    ```

5) verify the output of the plan in the terminal; if everything is fine, then apply the plan

    ```ftd
        terraform apply <out filename generated earlier>
    ```

6) Check the output and confirm it by typing "yes."

## Post Deployment Procedure

1) SSH to the instance by using ssh admin@PublicIP

*Note: The security group attached to the interfaces in this template allow traffic from anywhere. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports.*