
# FTDv single instance in an Availability Zone (AZ)

## Prerequisite

* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* aws v3.27.0 (signed by HashiCorp)
* aws hashicorp/template v2.2.0


## Overview

Using this Terraform template, a single instance of Virtual Cisco Secure Threat Defense Firewall (FTDv) can be deployed in a new or existing VPC with the following components: 

* 1x new VPC with 4 network subnets (2 Managment networks, 2 Data networks)
* 1x Availability Zone (AZ)
* 1x Network Security Groups/SG's (to allow all traffic)

*Note*: It is important to change the security group to allow only the traffic to and from the specific IP address/es and ports. 

* Routing table attachment to the specified subnets 
* Elastic IP address (EIP) attachment to the Managment and Outside network subnets 

We have provided the following two different example implementations for your convinience.

* **new_vpc.tfvars.example**: Creates a new VPC for the whole deployment.
* **existing_vpc.tfvars.example**: Uses your existing VPC for the deployment.


The following variables should be defined with the values in the "<strong>terraform.tfvars</strong>" file before using the templates, you can reference the above example files for the same.  

*Please note the value provided below is just for example, change it based on your requirements.*  

Specify your access key and secret key credentials:

## Credentials to access the AWS Cloud

<pre><code>
aws_access_key      = "enter your value here"

aws_secret_key      = "enter your value here"
</code></pre>
  
## Define your VPC name & existing KeyPair in a specific AWS Region & define FTD version 
<pre><code>
vpc_name            = "enter VPC name here"

existing_vpc        = false

region              = "enter AWS region here"

key_name            = "enter key pair name without pem extension here"

FTD_version         = "ftdv-7.3.0"

</code></pre>
*Note*: Key pair (in .pem format) are optional in nature & should be generated prior running Terraform template. 

## <ins> For existing VPC </ins>
>Note:The **existing_vpc** variable must be set to **true** if you intend to use your own, already created VPC. Skip this section otherwise.

### Define VPC CIDR block, Network Subnets for Managment(Maagement and Diagnostic) and Data networks (Inside and Outside)


<pre><code>
vpc_cidr           =  "enter VPC CIDR bock value here"

mgmt_subnet        =  "enter Management Network Subnet here"
outside_subnet     =  "enter Outside Network Subnet here"
diag_subnet        =  "enter Management/Diagnostic Network Subnet here"
inside_subnet      =  "enter Inside Network Subnet here"

ftd01_mgmt_ip       =  "enter management interface IP address
ftd01_outside_ip    =  "enter outside interface IP address"
ftd01_inside_ip     =  "enter inside interface IP address"
ftd01_diag_ip       =  "enter diagnostic interface IP address"
</code></pre>

### Define the Instance size for FTD and attach the interfaces and day0 configuration

<pre><code>
size                = "enter FTDv instance size here"
</code></pre>

Please refer the below FTDv in AWS Cloud Installation Guide to review the supported instance sizes: 
https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/aws/ftdv-aws-gsg/ftdv-aws-intro.html#Cisco_Concept.dita_3c4cfbdd-bdc1-4669-a892-31f5f7540e3e




Note: For updating FTDv 0-day configuration edit following file <strong>startup_file.json</strong>, that is part of this GitHub repository.


## Deployment Procedure

1. Clone or Download the Repository 
<pre><code>
$ git clone https://github.com/CiscoDevNet/secure-firewall.git
</code></pre>

2. Navigate to this specific terraform folder from the cli 
<pre><code>
$ cd <~folder path> 
</code></pre>

3. Customize the variables in the terraform.tfvars file by using any one of the 2 provided example files. 
<pre><code>
$ vim terraform.tfvars 
</code></pre>

4. Initialize the providers and modules:
<pre><code>
$ terraform init 
</code></pre>
   
5. Submit the terraform plan 
<pre><code>
$ terraform plan --out filename
</code></pre>
   
6. Verify the output of the plan in the terminal, if everything is fine then apply the plan
<pre><code> 
$ terraform apply filename
</code></pre>
   
7. If output is fine, configure it by typing "<strong>yes</strong>"

8. Once if executed, it will <strong>show you the ip addresss of the managment interface configured</strong>. use this to access the FTDv over HTTPs/SSH.

Note: Please don't delete or modify the file with the extension "<strong>.tfstate</strong>" file. This file maintained the current deployment status and used while modifying any parameters or while destroying this setup. 

## To Destroy the setup and FTDv instance created thru terraform. 

To destroy the instance, use the command:
<pre><code> 
$ terraform destroy 
</code></pre>

## Debugging

For debugging purposes and/or to set default values to variables you can leverage Terraform global environment variables. Here is example on how to enable and view debugging/trace logs for Linux/MacOS based OS:
<pre><code> 
$ export TF_LOG=trace
$ export TF_LOG_PATH=./terraform.log
</code></pre>

<pre><code> 
$ fail -f ./terraform.log
</code></pre>

For further details please refer to following guide: https://www.terraform.io/docs/cli/config/environment-variables.html![image](https://user-images.githubusercontent.com/81621190/116524607-dd598a80-a8d7-11eb-8170-1dee50a73902.png)

 
 # Disclaimer 
These repositories should be used only as a proof of concept. Also note that the statup/0-day files may include default password information. It is your duty to secure the provisioned device/s by following AWS and product based security best practises guidlines. 
 
