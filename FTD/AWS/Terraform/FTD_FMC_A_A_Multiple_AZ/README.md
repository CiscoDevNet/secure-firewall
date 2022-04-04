# Deployment of Active/Active FTDv(stateless) with NLB in Two different AZ with FMCv

## Prerequisite

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* aws v3.27.0 (signed by HashiCorp)
* aws hashicorp/template v2.2.0

## Overview

<img src="https://github.com/CiscoDevNet/secure-firewall/blob/main/FTD/AWS/Terraform/FTD_FMC_A_A_Multiple_AZ/FTD_AA_Multi_AZ.png" alt="FTD A/A in Single AZ" style="max-width:50%;">

Using this Terraform template, two instances of FTD will be deployed in  Active/Active using AWS native Network Load Balancer in two different Availability Zone, with FMC in a new VPC with the following components, 

- one new VPC with four subnets (1 Management networks, 3 data networks)
- Both the FTD and FMC deployed in the same Availability Zone
- Two network security group (one default and the other one is created to allow all traffic)
*Note*: With the default Security Group, the network is wide open. It is necessary to change the security group to allow only the required traffic to and from the specific IP address and ports. 

- Routing table attachment to each of these subnets. 
- EIP attachment to the Management and Outside subnets. 
- One External and One Internal Load Balancer.
 
Note: Internal Load Balancer is not used, and the External LB does the load balancing between the FTD for the N-S only. 

The following variables should be defined with a value in the "terraform. tfvars" file before using the templates. 
*Please note, the value provided below and in .tfvars are just examples. Please change it based on your requirements.*  

Specify your access key and secret key credentials 

## Credentials to access the AWS Cloud

aws_access_key      = ""

aws_secret_key      = ""
  
## Define New VPC in a specific Region and Availability Zone 

vpc_name            = "Transit-Service-VPC"

region                  = "ap-south-1"

## Define CIDR, Subnets for management, and three for Inside, Outside, and DMZ

vpc_cidr          	  =  "172.16.0.0/16"

mgmt01_subnet        = "172.16.0.0/24"

mgmt02_subnet        = "172.16.10.0/24"

outside01_subnet     = "172.16.2.0/24"

outside02_subnet     = "172.16.20.0/24"

inside01_subnet      = "172.16.3.0/24"

inside02_subnet      = "172.16.30.0/24"

dmz01_subnet         = "172.16.4.0/24" 

dmz02_subnet         = "172.16.40.0/24" 

## Define the Instance size for FTD and FMC, attach the interfaces and day0 configuration

Download the ASA_startup_file and update the configurations 

Please refer to the below ASAv datasheet for the supported "size." 
https://www.cisco.com/c/en/us/products/collateral/security/adaptive-security-virtual-appliance-asav/datasheet-c78-733399.html?dtid=osscdc000283

ftd01_mgmt_ip           =  "172.16.0.10" 
//FTD and FMC mgmt should be in the same subnet

fmc_mgmt_ip             =   "172.16.0.50"
//FTD and FMC mgmt should be in the same subnet

ftd01_outside_ip        =   "172.16.2.10"
 
ftd01_inside_ip         =  "172.16.3.10"

ftd01_dmz_ip            =  "172.16.4.10"

ftd02_mgmt_ip       =     "172.16.10.20"
//FTD and FMC mgmt should be in the same subnet

ftd02_outside_ip    =     "172.16.20.20"

ftd02_inside_ip     =     "172.16.30.20"       

ftd02_dmz_ip        =     "172.16.40.20"

#To configured the optional nat id while adding the manager
fmc_nat_id              =  ""

# To Configure the Load Balancer Listener Port
listener_ports      =  {
    80  =   "TCP"
    22  =   "TCP"
    443 =   "TCP"
}

health_check      =  {
    22  =   "TCP"
}

## Deployment Procedure

1) Clone or Download the Repository 
2) Input the values in the terraform ".tfvars" for variables in .tf 
3) Initialize the providers and modules
     - go to the specific terraform folder from the cli 
        $ cd xxxx
        $ terraform init 
 4) submit the terraform plan 
       $ terraform plan -out <filename>
 5) verify the output of the plan in the terminal; if everything is fine, then apply the plan 
        $ terraform apply <out filename generated earlier>
 6) Check the output and confirm it by typing "yes."


## Post Deployment Procedure

Once the FTD and FMC are successfully deployed, the following steps need to be done manually based on your requirement.

The Load balancing "Health Check" is configured to probe the FTD in port 22 through the external interfaces. If any of these fails, the FTD goes into unhealthy_state, and the traffic will go thru the healthy FTD.

To make "health_check" work, you need to enable the ssh in the FTD "platform settings" for the Loadbalancer IP address to access it, as mentioned in the below screenshot. 
<img src="https://github.com/CiscoDevNet/Cisco-FTD-PublicCloud/blob/main/AWS/Terraform/FTD_FMC_A_A_Multiple_AZ/FTD_Platformsetting_SSH.png" alt="FTD A/A in Single AZ" style="max-width:50%;">

This configuration is required if you want to NAT the workloads inside the network using the interface's IP address. Both source and destination NAT needs to be configured so that the traffic will be symmetric.


But usually, the servers inside the network, accessed from the public using the static NAT.  To achieve it, you need to configure the following things, 

1) Configure the secondary IP address set in the AWS External interfaces on both the FTDs. 
	For Example, if you have ten web servers to be accessed from outside, each external interface of AWS should be configured with ten IP addresses. 
2) Configure the Static NAT in FTD Firewall to map the inside host's IP addresses with the secondary IP addresses. 
3) Include the Dynamic Source NAT with the inside interface IP addresses of FTD so that the return traffic hits the same firewall. 
4) To have the Client's IP addresses' visibility, enable the "Preserve Client IP address" option in AWS Target group(s) attached with the load balancers. 

<img src="https://github.com/CiscoDevNet/Cisco-FTD-PublicCloud/blob/main/AWS/Terraform/FTD_FMC_A_A_Multiple_AZ/Preserver_IP_Client.png" alt="FTD A/A in Single AZ" style="max-width:50%;">


Note: There are different ways to configure the External Load Balancer and the FTDs to send the traffic across the FTDs for Active/Active Load Balancing with stateless failover. It differs based on the customer's network setup. The details mentioned above are just for the references.  
