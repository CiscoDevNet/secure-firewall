### Terraform Template to create a Single instance of FMCv, Ubuntu 18.04 LTS and Windows 10 all on the same Subnet.

Simple Usage
-----

This contains the bare minimum options to be configured for the VM to be provisioned.  The entire code block provisions a Windows, a Linux VM and Cisco FMCv 7.0.

An Ubuntu Server 18.04-LTS VM and a Windows 10 VM are provisioned using single VNet and opens up ports 22 for SSH and 3389 for RDP access via the attached public IP to each VM. The Ubuntu Server will use the ssh key found in the default location `~/.ssh/id_rsa.pub`.

All resources are provisioned into the default resource group called `FMC_RG`.

The Windows and Linux VM can be omitted if not required. The outputs are included to make it convenient to know the address to connect to the VMs after provisioning completes.


## Preinstallation

First step is to set up the a workstation to install Terrraform and Azure CLI. 

- Install Terraform on Ubuntu : [Doc](https://www.terraform.io/docs/cli/install/apt.html)

- Install Azure CLI on Ubuntu : [Doc](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

Make sure to login to Azure using below command to use Azure as a provider in Terraform template

`az login --use-device-code`

The template has been tested on :

- Terraform Version =  1.0.1
- Hashicorp AzureRM Provider = 2.65.0


Using this Terraform template, following resources will be deployed in azure.

- one new VPC with four subnets (1 Management networks, 3 data networks)
- Windows 10 instance with Public IP for Managament.
- Ubuntu 18.04 LTS with Public IP.
- FMCv instance with Public IP.

The variables should be defined with a value in the "terraform.tfvars" file before using the templates.

### Variables

| Variable | Meaning |
| --- | --- |
| `resource_group_name = "FMC_RG"` | Resorce group Name in Azure |
| `resource_group_location = "centraleurope"` | Resorce group Location in Azure |
| `virtual_network_name = "vnetprod01"` | Virtual Network in Azure |
| `subnet_name_1 = "subnet01"` | Subnet name in Azure |
| `subnet_name_2 = "subnet02"` | Subnet name in Azure |
| `subnet_name_3 = "subnet03"` | Subnet name in Azure |
| `subnet_name_4 = "subnet04"` | Subnet name in Azure |
| `public_ip_ubuntu = "publicip01"` | public ip name of linux VM |
| `public_ip_win = "publicip02"` | public ip name of windows VM |
| `public_ip_fmc = "publicfmcip01"` | public ip name of FMCv VM |
| `network_security_group_VM = "nsgprod01"` | Network Security Group for Windows and FMCv VM |
| `network_security_group_ALL = "nsgprod02"` | Network Security Group for linux VM |
| `network_interface_win = "nicwin01"` | Network interface name of Windows VM |
| `network_interface_name = "nicprod01"` | Network interface name of linux VM |
| `network_interface_fmc = "fmcmgmt"` | Network interface name of FMCv VM |
| `linux_virtual_machine_name = "linuxvm01"` | Linux VM name |
| `fmc_virtual_machine_name = "linuxvm01"` | FMCv VM name |
| `win_virtual_machine_name = "linuxvm01"` | Windows VM name |
| `fmc_version = "70094.0.0"` | FMCv Version |


### SSH Keys creation;

1) ```
     - Check for existing key 
        $ cd ~/.ssh
        $ ls
    ```
2) ```
     - If no keys exist, generate new keys
        $ ssh-keygen -o
        Generating public/private rsa key pair.
    ```
3) ```
     - validate key 
        $ cat ~/.ssh/id_rsa.pub
    ```


## Deployment Procedure

1) Clone or Download the Repository
2) Input the values in the terraform ".tfvars" for variables in .tf
3) Initialize the providers and modules

    ```
     - go to the specific terraform folder from the cli 
        cd xxxx
        terraform init 
    ```

4) submit the terraform plan

    ```
       terraform plan -out <filename>
    ```

5) verify the output of the plan in the terminal; if everything is fine, then apply the plan

    ```
        terraform apply <out filename generated earlier>
    ```

6) Check the output and confirm it by typing "yes."

## Post Deployment Procedure

1) SSH to the instance by using ssh admin@PublicIP
 
*Note: The security group attached to the interfaces in this template allow traffic from anywhere. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports.*

