## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Programmatic access to AWS account with CLI - learn how to set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- Optional - if this your first time of using ASAv instances on this account, you have to read and accept the AWS Marketplace terms of the image and subscribe to it first by visiting next link:
- https://aws.amazon.com/marketplace/pp?sku=bhx85r4r91ls2uwl69ajm9v1b

The template has been tested on :
- Terraform = v1.0.1

## Overview

Using this Terraform template, `n` instances of FMCv will be deployed in AWS based on the user requirement, with the following components:

- One new VPC with one subnet per Availability Zone (1 management network). Or existing VPC can be used instead.
- Routing table attachment to each of subnet(s) with a default route pointing to the internet gateway.
- Public IP attachment to the each FMCv instance.

In case of existing VPC, if there is an internet gateway attached to the VPC, the internet gateway ID should be provided otherwise a new Internet Gateway will be created for the VPC.

FMCv Management Subnets will be created in each Availability Zone where the instances will be deployed. If no subnet CIDR blocks are provided then the 1st subnet formed based on the subnet size provided will be used and subsequent subnets based on the number of subnets to be created.

### Instances distribution

If there is more than `1` instance of FMCv, it will be distributed by Availability Zones (AZ) automatically in a round robin manner. One can set preference for specific AZ in `azs` parameter.

*Please note, if there is more than `1` instance, yet only one AZ set in `azs` parameter - all instances will be placed in single AZ.*


### Parameters

The following variables should be defined with a value in the "terraform.tfvars" file before using the templates. 
*Please note, the value provided below and in .tfvars are just examples. Please change it based on your requirements.*

| Parameter | Meaning |
| --- | --- |
| `aws_access_key` | Access key ID |
| `aws_secret_key` | Secret access key |
| `region` | AWS Region |
| `azs = []` | list of AWS Availability Zones to deploy FMCv instances |
| `name_tag_prefix = "FMCv"` | Prefix for the 'Name' tag of the resources |
| `instances = 1` | Number of FMCv instances |
| `fmc_version = "fmcv-7.0.0"` | Version of the FMCv |
| `fmc_size = "c5.4xlarge"` | Size of the FMCv instance |
| `vpc_name = "Cisco-FMCv"` | VPC Name |
| `vpc_id = ""` | Existing VPC ID |
| `vpc_cidr = "10.0.0.0/16"` | VPC CIDR |
| `subnet_size = 24` | Size of Management subnet |
| `igw_id = ""` | Existing Internet Gateway ID |
| `password = "P@$$w0rd1234"` | Password for FMCv |
| `hostname = "fmc"` | FMCv OS hostname |
| `key_name` | Existing Outside subnet ID |
| `subnets = []` | Subnets to be created |



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
1) SSH to the instance by using ssh admin@PublicIP
     
*The admin password to be used can be provided in the user_data file*

*Note: The security group attached to the interfaces in this template allow all traffic. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports.*

