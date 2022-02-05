# AWS GWLB Centralized Architecture with Transit Gateway setup

## Overview

Using this Terraform template, AWS Transit Gateway to connect VPCs will be created in AWS based on the user parameters, with the following components:

- One TGW subnet per AZ in service VPC
- One TGW subnet per AZ in spoke VPC or use existing subnets provider as input
- Transit Gateway
- Attachments for Transit Gateway to service and spoke vpc
- Routing table attachment to each of these subnets
- Routing rules for Transit Gateway
- If NAT Subnet IDs and GWLBE Subnet associasted Route table IDs are provided,routes will be added to their route tables for centralized architecture traffic flow.

*Appliance mode is enabled for service VPC Transit Gateway Attachment*

## Topology



## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- Programmatic access to AWS account with CLI - learn how to set up [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

The template has been tested on :
- Terraform = v1.0.11

### Parameters

The following variables should be defined with a value in the "terraform.tfvars" file before using the templates. 
*Please note, the value provided below and in .tfvars are just examples. Please change it based on your requirements.*

| Parameter | Meaning | Required |
| --- | --- | --- |
| `aws_access_key` | Access key ID | Y |
| `aws_secret_key` | Secret access key | Y |
| `region` | AWS Region | Y |
| `vpc_service_id` | Existing Service VPC ID | Y |
| `vpc_spoke_id` | Existing Spoke VPC ID | Y |
| `subnet_spoke_namE` | Name of the spoke TGW subnet being created | N |
| `subnet_service_name` | Name of the service TGW subnet being created | N |
| `cidr_spoke_sub ` | CIDRs for new spoke TGW subnets | N|
| `id_spoke_sub` | IDs for existing spoke subnets | N |
| `cidr_service_sub`| CIDRs of the service TGW Subnet | Y | 
| `gwlbe` | Gateway load balancer endpoint IDs | Y |
| `transit_gateway_name` | Transit Gateway Name | N |
| `aws_availability_zones` | List of AZs to distribute service subnets | Y |
| `NAT_Subnet_Routetable_IDs` | list of Route table IDs associated with NAT Subnets | N |
| `GWLBE_Subnet_Routetable_IDs` | list of Route table IDs associated with GWLBE Subnets | N |


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

* will need to add route to spoke subnet in the NAT GATEWAT and GWLBE subnets