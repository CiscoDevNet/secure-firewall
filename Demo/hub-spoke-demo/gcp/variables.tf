# Project Configuration
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for resources"
  type        = string
  default     = "us-central1-a"
}

# Resource Naming
variable "resource_prefix" {
  description = "Prefix for all GCP resource names"
  type        = string
  default     = "C15C0"
}

# Common Labels
variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "C15C0-automation"
    owner       = "terraform"
  }
}

# VPC CIDR Blocks
variable "security_vpc_cidr" {
  description = "CIDR block for Security VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke1_vpc_cidr" {
  description = "CIDR block for Spoke1 VPC"
  type        = string
  default     = "172.0.0.0/16"
}

variable "spoke2_vpc_cidr" {
  description = "CIDR block for Spoke2 VPC"
  type        = string
  default     = "192.0.0.0/16"
}

# Security VPC Subnet CIDRs
variable "management_subnet_cidr" {
  description = "CIDR block for Management subnet in Security VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "diagnostic_subnet_cidr" {
  description = "CIDR block for Diagnostic subnet in Security VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "outside_subnet_cidr" {
  description = "CIDR block for Outside subnet in Security VPC"
  type        = string
  default     = "10.0.2.0/24"
}

variable "inside_subnet_cidr" {
  description = "CIDR block for Inside subnet in Security VPC"
  type        = string
  default     = "10.0.3.0/24"
}

# Spoke VPC Subnet CIDRs
variable "spoke1_private_subnet_cidr" {
  description = "CIDR block for private subnet in Spoke1 VPC"
  type        = string
  default     = "172.0.1.0/24"
}

variable "spoke2_private_subnet_cidr" {
  description = "CIDR block for private subnet in Spoke2 VPC"
  type        = string
  default     = "192.0.1.0/24"
}

# FTDv Firewall IP Addresses
variable "ftdv_egress_management_ip" {
  description = "Management IP for Egress FTDv firewall"
  type        = string
  default     = "10.0.0.10"
}

variable "ftdv_egress_diagnostic_ip" {
  description = "Diagnostic IP for Egress FTDv firewall"
  type        = string
  default     = "10.0.1.10"
}

variable "ftdv_egress_outside_ip" {
  description = "Outside IP for Egress FTDv firewall"
  type        = string
  default     = "10.0.2.10"
}

variable "ftdv_egress_inside_ip" {
  description = "Inside IP for Egress FTDv firewall"
  type        = string
  default     = "10.0.3.10"
}

variable "ftdv_ingress_management_ip" {
  description = "Management IP for Ingress FTDv firewall"
  type        = string
  default     = "10.0.0.20"
}

variable "ftdv_ingress_diagnostic_ip" {
  description = "Diagnostic IP for Ingress FTDv firewall"
  type        = string
  default     = "10.0.1.20"
}

variable "ftdv_ingress_outside_ip" {
  description = "Outside IP for Ingress FTDv firewall"
  type        = string
  default     = "10.0.2.20"
}

variable "ftdv_ingress_inside_ip" {
  description = "Inside IP for Ingress FTDv firewall"
  type        = string
  default     = "10.0.3.20"
}

variable "ftdv_eastwest_management_ip" {
  description = "Management IP for East-West FTDv firewall"
  type        = string
  default     = "10.0.0.30"
}

variable "ftdv_eastwest_diagnostic_ip" {
  description = "Diagnostic IP for East-West FTDv firewall"
  type        = string
  default     = "10.0.1.30"
}

variable "ftdv_eastwest_outside_ip" {
  description = "Outside IP for East-West FTDv firewall"
  type        = string
  default     = "10.0.2.30"
}

variable "ftdv_eastwest_inside_ip" {
  description = "Inside IP for East-West FTDv firewall"
  type        = string
  default     = "10.0.3.30"
}

# FTDv Configuration
variable "cisco_product_version" {
  description = "Cisco FTDv product version"
  type        = string
  default     = "cisco-ftdv-7-0-0-94"
}

variable "ftdv_machine_type" {
  description = "Machine type for FTDv instances"
  type        = string
  default     = "e2-standard-4"
}

variable "ftdv_admin_username" {
  description = "Admin username for FTDv instances"
  type        = string
  default     = "cisco"
}

variable "ftdv_admin_password" {
  description = "Admin password for FTDv instances"
  type        = string
  sensitive   = true
}

variable "admin_ssh_pub_key" {
  description = "SSH public key for FTDv instances"
  type        = string
  default     = ""
}

# VM Configuration
variable "vm_machine_type" {
  description = "Machine type for test VMs"
  type        = string
  default     = "e2-micro"
}

variable "vm_admin_username" {
  description = "Admin username for test VMs"
  type        = string
  default     = "ubuntu"
}

# SCCFM and FMC Configuration
variable "scc_host" {
  description = "SCC Host URL"
  type        = string
}

variable "cdfmc_host" {
  description = "cdFMC URL"
  type        = string
}

variable "scc_token" {
  description = "CDO Token"
  type        = string
  sensitive   = true
}