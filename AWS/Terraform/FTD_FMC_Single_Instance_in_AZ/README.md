
# FTDv and FMCv in single instances in a AZ

## Prerequisite

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* aws v3.27.0 (signed by HashiCorp)
* aws hashicorp/template v2.2.0


## Overview

Using this Terraform template, a single instance of FTD and FMC will be deployed in a new VPC with the following components, 

- one new VPC with 5 subnets (2 Managment networks, 3 data networks)
- Avilability Zone
- Two network security group (one default and other one is created to allow all traffic)

*Note*: It is important to change the security group to allow only the traffic to and from the sepcific ip address and ports. 

- Routing table attachment to these subnets 
- EIP attachment to the Managment and Outside subnets. 

The following variables should be defined with the values in the "terraform.tfvars" file before using the templates. 
*Please note the value provided below is just for example, change it based on your requirements.*  

Specify your access key and secret key credentials 


## Creditials to access the AWS Cloud

aws_access_key      = ""

aws_secret_key      = ""
  
## Define New VPC in a specific Region and Avilability Zone 

vpc_name            = "Transit-Service-VPC"

region              = "ap-south-1"

aws_az              = "ap-south-1a"


## Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ

vvpc_cidr          =  "172.16.0.0/16"

mgmt_subnet        =  "172.16.0.0/24"

diag_subnet        =  "172.16.1.0/24"

outside_subnet      =  "172.16.2.0/24"
 
inside_subnet      =  "172.16.3.0/24"

dmz_subnet         =  "172.16.4.0/24"

key_name             = "NGFW-KP"   --> .pem key file should be generated before



## Define the Instance size for FTD and FMC and attach the interfaces and day0 configuration

ASA Interfaces IP address Configurations 
Download the ASA_startup_file and update the configurations 

Please refer the below ASAv datasheet for the supported "size" 
https://www.cisco.com/c/en/us/products/collateral/security/adaptive-security-virtual-appliance-asav/datasheet-c78-733399.html?dtid=osscdc000283

ftd01_mgmt_ip       =  "172.16.0.10" 
//FTD and FMC mgmt should be in the same subnet

fmc_mgmt_ip        =   "172.16.0.50"
//FTD and FMC mgmt should be in the same subnet

ftd01_outside_ip    =   "172.16.2.10"
 
ftd01_inside_ip     =  "172.16.3.10"

ftd01_dmz_ip        =  "172.16.4.10"

## Deployment Procedure

1) Clone or Download the Repository 
2) Customize the variables in the terraform.tfvars and variables.tf (only to change the default value)
3) Initialize the providers and modules
     - go to the specific terraform folder from the cli 
        $ cd xxxx
        $ terraform init 
 4) submit the terraform plan 
       $ terraform plan -out <filename>
 5) verify the output of the plan in the terminal, if everything is fine then apply the plan 
        $ terraform apply <out filename generated earlier>
 6) if output is fine, configure it by typing "yes"
 7) Once if exected, it will show you the ip addresss of the managment interface configured. use this to access the ASA

Note: Please don't delete or modify the file with the extension ".tfstate" file. This file maintained the current deployment status and used while modifying any parameters or while destroying this setup. 

## To Destroy the setup and FTDv and FMCv instance created thru terraform. 
To destroy the instance, use the command:
     $ terraform destroy 
 
 # Disclaimer 
 <TBD>
 
