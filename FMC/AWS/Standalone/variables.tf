#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  description = "AWS Region"
}

variable "azs" {
  default     = []
  description = "AWS Availability Zones"
}

variable "name_tag_prefix" {
  default     = "FMCv"
  description = "Prefix for the 'Name' tag of the resources"
}

variable "instances" {
  default     = 1
  description = "Number of FMCv instances"
}

variable "fmc_version" {
  default     = "fmcv-7.0.0"
  description = "Version of the FMCv"
}

variable "fmc_size" {
  default     = "c5.4xlarge"
  description = "Size of the FMCv instance"
}

variable "vpc_name" {
  default     = "Cisco-FMCv"
  description = "VPC Name"
}

variable "vpc_id" {
  default     = ""
  description = "Existing VPC ID"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "subnet_size" {
  default     = 24
  description = "Size of Management subnet"
}

variable "igw_id" {
  default     = ""
  description = "Existing Internet Gateway ID"
}

variable "password" {
  default     = "P@$$w0rd1234"
  description = "Password for FMCv"
  sensitive   = true
}

variable "hostname" {
  default     = "fmc"
  description = "FMCv OS hostname"
}

variable "key_name" {
  description = "AWS EC2 Key"
}

variable "subnets" {
  default     = []
  description = "mgmt subnets"
}
