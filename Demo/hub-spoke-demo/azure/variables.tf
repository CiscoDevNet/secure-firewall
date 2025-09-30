# Resource Naming
variable "resource_prefix" {
  description = "Prefix for all Azure resource names"
  type        = string
  default     = "C15C0"
}

# Azure Region
variable "azure_region" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
# SCC/FMC Configuration
variable "scc_token" {
  description = "API token for Cisco Security Cloud"
  type        = string
  sensitive   = true
}

variable "scc_host" {
  description = "Base URL for Cisco Security Cloud"
  type        = string
}
variable "cdfmc_host" {
  description = "Cisco Defense Manager (FMC) hostname"
  type        = string
}

# Security Configuration
variable "trusted_networks" {
  description = "List of trusted network CIDR blocks allowed for inbound traffic"
  type        = list(string)
  default = [
    "172.0.0.0/8",
    "192.0.0.0/8",
    "10.0.0.0/8",
    "151.0.0.0/8"
  ]
}

# Virtual Network CIDR Blocks
variable "security_vnet_cidr" {
  description = "CIDR block for Security VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke1_vnet_cidr" {
  description = "CIDR block for Spoke1 VNet"
  type        = string
  default     = "172.0.0.0/16"
}

variable "spoke2_vnet_cidr" {
  description = "CIDR block for Spoke2 VNet"
  type        = string
  default     = "192.0.0.0/16"
}

# Security VNet Subnet CIDRs
variable "management_subnet_cidr" {
  description = "CIDR block for Management subnet in Security VNet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "diagnostic_subnet_cidr" {
  description = "CIDR block for Diagnostic subnet in Security VNet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "outside_subnet_cidr" {
  description = "CIDR block for Outside subnet in Security VNet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "inside_subnet_cidr" {
  description = "CIDR block for Inside subnet in Security VNet"
  type        = string
  default     = "10.0.3.0/24"
}

# Spoke VNet Subnet CIDRs
variable "spoke1_private_subnet_cidr" {
  description = "CIDR block for private subnet in Spoke1 VNet"
  type        = string
  default     = "172.0.1.0/24"
}

variable "spoke2_private_subnet_cidr" {
  description = "CIDR block for private subnet in Spoke2 VNet"
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
variable "ftdv_vm_size" {
  description = "Azure VM size for FTDv instances"
  type        = string
  default     = "Standard_D3_v2"
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

# Test VM Configuration
variable "vm_size" {
  description = "Azure VM size for test VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for test VMs"
  type        = string
  default     = "cisco"
}

variable "admin_password" {
  description = "Admin password for test VMs"
  type        = string
  sensitive   = true
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "C15C0-automation"
    Owner       = "terraform"
  }
}
variable "ftd_image_version" {
  description = "FTDv image version"
  type        = string
  default     = "77089.0.0"
}