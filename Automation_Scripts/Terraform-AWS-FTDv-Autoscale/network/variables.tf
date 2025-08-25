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

# Service VPC
variable "srvc_cidr" {
  default = "10.0.0.0/16"
}
variable "mgmt_subnet" {
  default = "10.0.0.0/24"
}
variable "data_subnet" {
  default = "10.0.1.0/24"
}
variable "ccl_subnet" {
  default = "10.0.2.0/24"
}
variable "lambda_subnet" {
  default = "10.0.3.0/24"
}
variable "ftd_mgmt_private_ip" {
  default = "10.0.0.10"
}
variable "fmc_mgmt_private_ip" {
  default = "10.0.0.50"
}

# App VPC
variable "app_cidr" {
  default = "10.1.0.0/16"
}
variable "gwlbe_subnet" {
  default = "10.1.0.0/24"
}
variable "app_subnet" {
  default = "10.1.1.0/24"
}

variable pod_number {
  description = "This will be suffixed to AutoScale Group(NGFWv-Group-Name), if this value is 1 then, group name will be NGFWv-Group-Name-1, It should be at least 1 numerical digit but not more than 3 digits."
  type = string
  default = 1
}

variable assign_public_ip {
  description = "Please select true if  needs to have public IP address. In case NGFWv needs to have public IP then management subnet should have AWS IGW as route to internet."
  type = string
  default = true
}
