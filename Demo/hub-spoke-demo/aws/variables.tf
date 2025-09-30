# Global Variables
variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "C15C0"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
  
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true

}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-northeast-3a", "ap-northeast-3b"]
}

# VPC CIDR Blocks
variable "security_vpc_cidr" {
  description = "CIDR block for Security VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke1_vpc_cidr" {
  description = "CIDR block for Spoke-1 VPC"
  type        = string
  default     = "172.0.0.0/16"
}

variable "spoke2_vpc_cidr" {
  description = "CIDR block for Spoke-2 VPC"
  type        = string
  default     = "192.0.0.0/16"
}

# Security VPC Shared Subnet Configuration (All 3 firewalls share these 4 subnets)
variable "management_subnet_cidr" {
  description = "CIDR for Management subnet (shared by all FTDv instances)"
  type        = string
  default     = "10.0.0.0/24"
}

variable "diagnostic_subnet_cidr" {
  description = "CIDR for Diagnostic subnet (shared by all FTDv instances)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "outside_subnet_cidr" {
  description = "CIDR for Outside subnet (shared by all FTDv instances)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "inside_subnet_cidr" {
  description = "CIDR for Inside subnet (shared by all FTDv instances)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "tgw_subnet_cidr" {
  description = "CIDR for Transit Gateway subnet (dedicated for TGW attachment)"
  type        = string
  default     = "10.0.4.0/24"
}

# Spoke VPC Subnet Configuration
variable "spoke1_private_subnet_cidr" {
  description = "CIDR for Spoke-1 private subnet"
  type        = string
  default     = "172.0.1.0/24"
}

variable "spoke2_private_subnet_cidr" {
  description = "CIDR for Spoke-2 private subnet"
  type        = string
  default     = "192.0.1.0/24"
}

# FTDv Instance Configuration
variable "ftdv_instance_type" {
  description = "Instance type for FTDv"
  type        = string
  default     = "c5.xlarge"
}

variable "ftdv_version" {
  description = "FTDv version"
  type        = string
  default     = "7.4.1-204"
}

variable "ftdv_password" {
  description = "Admin password for FTDv (minimum 8 characters)"
  type        = string
  sensitive   = true
  default     = "Admin@123456"
}

# Ubuntu Instance Configuration
variable "ubuntu_instance_type" {
  description = "Instance type for Ubuntu instances"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access"
  type        = string
  default     = "cisco-ftdv-keypair"
}

# Tags
variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "lab"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "cisco-secure-firewall"
}

variable "scc_host"{
  type    = string
}
variable "cdfmc_host" {
  type        = string
  description = "cdFMC URL"
}
variable "scc_token" {
  type        = string
  description = "CDO Token"
}
variable "FTD_version" {
  
}
###