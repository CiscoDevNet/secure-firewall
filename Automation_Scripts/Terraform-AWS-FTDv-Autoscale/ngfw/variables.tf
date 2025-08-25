##############
# Variables
##############

# Environment

# Env name is tagged on all resources
variable "env_name" {
  default = "NGFW"
}

# AWS
variable "aws_access_key" {
  description = "Pass this value using tfvars file"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "Pass this value using tfvars file"
  type = string
  sensitive = true
}
variable "region" {
  type = string
}
variable "aws_az" {
  type = string
}

# Secure Firewall

# If creating FMCv in VPC then true, if using cdFMC then false.
variable "create_fmcv" {
  description = "true or false - pass this value using tfvars file"
  type        = bool
}

variable "ftd_pass" {
  description = "FTD and FMC password - pass this value using tfvars file"
  type        = string
  sensitive   = true
}
variable "ftd_reg_key" {
  description = "Key to register to FMC - pass this value using tfvars file"
  type        = string
  sensitive   = true
}
variable "ftd_nat_id" {
  description = "ID to register to FMC - pass this value using tfvars file"
  type        = string
  sensitive   = true
}
variable "cdFMC" {
  description = "Hostname for connecting to cdFMC instance"
  type        = string
}

variable "cdo_token" {
  description = "Token used for authenticating cdFMC instance - pass this value using tfvars file"
  type        = string
}

variable "fmc_mgmt_private_ip" {
  default = "10.0.0.50"
}

variable "app_server" {
  default = "10.1.1.100"
}

variable "app_subnet" {
  default = "10.1.1.0/24"
}

variable "auto_scale_desired_group_size" {
  type = number
  default = 0
}

variable "auto_scale_min_group_size" {
  type = number
  default = 0
}

variable "auto_scale_max_group_size" {
  type = number
  default = 2
}

variable pod_number {
  description = "This will be suffixed to AutoScale Group(NGFWv-Group-Name), if this value is 1 then, group name will be NGFWv-Group-Name-1, It should be at least 1 numerical digit but not more than 3 digits."
  type = string
  default = 1
}

variable notify_email {
  description = "Email address to which AutoScale Events Email needs to be sent."
  type = string
}

variable tg_health_port {
  description = "Note By default this port shouldn't be used for traffic, because any request coming to NGFWv having destination port as this will be routed to AWS Metadata server. If you want your application itself to reply for health probes then accordingly NAT rules can be changed for NGFWv. In such case if application doesn't respond then FTDv will be marked as unhealthy and gets deleted due to Unhealthy instance threshold alarm."
  type = string
  default = 22
}

variable assign_public_ip {
  description = "Please select true if  needs to have public IP address. In case NGFWv needs to have public IP then management subnet should have AWS IGW as route to internet."
  type = string
  default = true
}

variable license_type {
  description = "Choose Cisco NGFWv EC2 instance license type, make sure AMI ID which will be entered below is of same licensing type."
  type = string
  default = "BYOL"
}

variable ngfw_password {
  description = "All NGFWv instances come up with default password, which is in Userdata field of Launch Template(Autoscale Group). Password will be changed to given(below) password once NGFWv is accessible. Since this can be a plain text password or KMS encrypted password, minimum length should be 8 characters."
  type = string
}

variable fmc_username {
  description = "Username to log into FMC"
  type = string
}

variable fmc_password {
  description = "Password to log into FMC"
  type = string
}

variable fmc_insecure_skip_verify {
  description = "Should FMC allow self-signed certificates"
  type = bool
  default = true
}

variable is_cdfmc {
  description = "Is FMC cloud hosted"
  type = bool
  default = true
}

variable cdfmc_domain_uuid {
  description = "cdFMC device UUID"
  type = string
  default = "e276abec-e0f2-11e3-8169-6d9ed49b625f"
}

variable fmc_device_grp_name {
  description = "Please make sure correct Device Group Name in FMC is provided"
  type = string
  default = "NGFW_AutoScale"
}

variable fmc_performance_license_tier {
  description = "Please make sure you select the correct performance Tier License to be used while registering the ftdv device to the FMCv. FTDv5 & FTDv10 do not support Amazon Web Services (AWS) Gateway Load Balancer."
  type = string
  default = "FTDv50"
}

variable fmc_publish_metrics {
  description = "Please select true if you would like to create a Lambda Function to poll FMC, and publish a specific Device Group Metrics to AWS CloudWatch."
  type = string
  default = true
}

variable fmc_metrics_username {
  description = "Unique Internal user for Polling Metrics from FMC, User should have roles system provided 'Network Admin' and 'Maintenance User' or more. Refer 'Firepower Management Center Configuration Guide'"
  type = string
  default = "metrics_admin"
}

variable fmc_metrics_password {
  description = "Please make sure you type correct password (Wrong password will result in failure of Metrics collection). If KMS ARN is specified above, please provide encrypted password."
  type = string
  default = "C1sco!23"
}

variable cpu_thresholds {
  description = "[Optional] Specifying non-zero lower and upper threshold will create respective Scale policies. If 0,0 is selected, no cpu scaling alarm or policies will be created. Evaluation points & Data points are kept default/recommended values"
  type = string
  default = "10,70"
}

variable memory_thresholds {
  description = "[Optional] Specifying non-zero lower and upper threshold will create respective Scale policies. If 0,0 is selected, no memory scaling alarm or policies will be created. Note, if Metric publish Lambda is not created then this input will be ignored irrespective of chosen values."
  type = string
  default = "40,70"
}

variable "cdo_region" {
  description = "us, eu, apj"
  default = "us"
}



#################################################################
# Local Variables
#################################################################
locals {
  # If "create_fmcv" is TRUE, use FMCv variables, if FALSE use cdFMC variables.
  fmc_user = var.create_fmcv ? var.fmc_username : null
  fmc_pass = var.create_fmcv ? var.fmc_password : null
  fmc_host = var.create_fmcv ? var.fmc_mgmt_private_ip : var.cdFMC
  fmc_url = var.cdFMC
  is_cdfmc = var.create_fmcv ? false : true
  cdo_token = var.create_fmcv ? null : var.cdo_token
  cdfmc_domain_uuid = var.create_fmcv ? null : var.cdfmc_domain_uuid

  # If variable "create_fmcv" is "true" then ftd_mgmt_ip will be private ip address
  # if variable "create_fmcv" is "false" then ftd_mgmt_ip will be public ip address
  fmc_mgmt_ip = var.create_fmcv ? var.fmc_mgmt_private_ip : var.cdFMC
}