# ASAv single instances in a AZ

## Prerequisite

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* aws v3.27.0 (signed by HashiCorp)
* aws hashicorp/template v2.2.0


## Overview

Using this Terraform template, a single instance ASA can be deployed in a new VPC with the following components, 

- one new VPC with 4 subnets
- Avilability Zone
- Two network securit group (one default and other one is created to allow all traffic)

*Note*: It is important to change the security group to allow only the traffic from and to the sepcific ip address and ports. 

- Routing table attachment to these subnets 
- EIP attachment to the Managment and Outside subnet. 

The following parameters should be configured in the "terraform.tfvars" file before using the templates. 
*Please note the value provided below is just for example.Please change it based on your requirements.*  

Specify your access key and secret key credentials 


## AWS Creditials to access the AWS Cloud

aws_access_key      = ""

aws_secret_key      = ""
  
## Define New VPC in a specific Region and Avilability Zone 

vpc_name            = "Transit-Service-VPC"

region               = "ap-south-1"


## Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ

vpc_cidr           = "10.1.0.0/16"

mgmt_subnet        = "10.1.0.0/24"

outside_subnet     = "10.1.1.0/24"

inside_subnet      = "10.1.2.0/24"

dmz_subnet         = "10.1.3.0/24" 

key_name             = ""  --> .pem key file should be generated before



## Define the Instance size of ASA and attach the interfaces and day0 configuration

ASA Interfaces IP address Configurations 
Download the ASA_startup_file and update the configurations 

Please refer the below ASAv datasheet for the supported "size" 
https://www.cisco.com/c/en/us/products/collateral/security/adaptive-security-virtual-appliance-asav/datasheet-c78-733399.html?dtid=osscdc000283

size                = "c5.xlarge"

ASA_version         = "asav9-15-1-1"
//Allowed Values = asav9-15-1, asav9-14-1-30, asav9-12-4-4, asav9-14-1-10, asav9-13-1-12

asa_mgmt_ip       =     "10.1.0.10"

asa_outside_ip    =     "10.1.1.10"  

asa_inside_ip     =     "10.1.2.10"       

asa_dmz_ip        =     "10.1.3.10"

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

## To Destroy the setup and ASAv instance created thru terraform. 
To destroy the instance, use the command:
     $ terraform destroy 
 
 # Disclaimer 
 <TBD>
 
