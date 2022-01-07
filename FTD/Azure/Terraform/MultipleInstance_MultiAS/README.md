### Terraform Template to create Multiple Instance of FTDv in an availability set in a location.

## Preinstallation

First step is to set up the Linux server to install Terrraform and Azure CLI.

- Install Terraform on Ubuntu : [Doc](https://www.terraform.io/docs/cli/install/apt.html)

- Install Azure CLI on Ubuntu : [Doc](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

Make sure to login to Azure using below command to use Azure as a provider in Terraform template

`az login --use-device-code`

The template has been tested on :

- Terraform Version =  0.14.7
- Hashicorp AzureRM Provider = 2.53.0


Using this Terraform template, n instances of FTD will be deployed in azure.

- one new VPC with four subnets (2 Management networks, 2 data networks)
- Routing table attachment to each of these subnets. 
- EIP attachment to the Management subnet. 
- One External and One Internal Load Balancer.

The variables should be defined with a value in the "terraform. tfvars" file before using the templates.

### Variables

| Variable | Meaning |
| --- | --- |
| `location = "centraleurope"` | Resorce group Location in Azure |
| `prefix = "cisco-ftdv"` | This would prefix all the component with this string |
| `source-address = "*"` | Limit the Management access to specific source IPs |
| `IPAddressPrefix = "10.10"` | All the IP Address segment will use this as prefix with .0,.1,.2 and .3 as the 3rd octet |
| `Version = "67065.0.0"` | FTD Version to be deployed - Please validate the correct version using - `az vm image list --offer ftdv --all` |\
| `VMSize = "Standard_D3_v2"` | Size of the FTDv to be deployed |
| `RGName = "cisco-ftdv-RG"` | Resource Group Name |
| `instancename = "cisco-ftdv"` | Instance Name and properties of FTDv |
| `fmc_ip = "Change Me"` | FMC IP to be used as manager for FTD |
| `password = "P@$$w0rd1234"` | Password to login to FTD |
| `instances = 2` | Number of instances of FTD |

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

Administrator will need to allow SSH on interface for Probe check and put in routes as described in the video for further testing : https://www.youtube.com/watch?v=Zjc9hmc2m68
