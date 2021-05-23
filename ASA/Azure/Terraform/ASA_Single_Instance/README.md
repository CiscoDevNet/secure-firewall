### Terraform Template to create Single Instance of ASAv in a single location.

First step is to set up the Linux server to install Terrraform and Azure CLI.

- Install Terraform on Ubuntu : https://www.terraform.io/docs/cli/install/apt.html

- Install Azure CLI on Ubuntu : https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt

Make sure to login to Azure using below command to use Azure as a provider in Terraform template

`az login --use-device-code`



The template has been tested on :
- Terraform Version =  0.14.7
- Hashicorp AzureRM Provider = 2.47.0

There are total 22 resources that are added which can be verified using 
`terraform plan`

