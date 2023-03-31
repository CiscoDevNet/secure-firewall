#####################################################################################################################
# Variables
#####################################################################################################################

variable "location" {
  default     = "eastus2"
  description = "Azure region"
}

variable "prefix" {
  default     = "cisco-ASAv"
  description = "Prefix to prepend resource names"
}

variable "create_rg" {
  default     = true
  description = "Wheather to create Resource Group"
}

variable "rg_name" {
  default     = "cisco-ASAv-RG"
  description = "Azure Resource Group"
}

variable "create_vn" {
  default     = true
  description = "Wheather to create Virtual Network"
}

variable "vn_name" {
  default     = ""
  description = "Existing Virtual Network Name"
}

variable "vn_cidr" {
  default     = "10.0.0.0/16"
  description = "Virtual Network CIDR"
}


variable "subnet_size" {
  default     = 24
  description = "Size of Subnets"
}

variable "source_address" {
  default     = "*"
  description = "Limit the Management access to specific source"
}

variable "azs" {
  default = [
    "1",
    "2",
    "3"
  ]
  description = "Azure Availability Zones"
}

variable "instances" {
  default     = 2
  description = "Number of ASAv instances"
}

variable "vm_size" {
  default     = "Standard_D3_v2"
  description = "Size of the VM for ASAv"
}

variable "instancename" {
  default     = "ASAv"
  description = "ASAv instance Name"
}

variable "username" {
  default     = "cisco"
  description = "Username for the VM OS"
}

variable "password" {
  default     = "P@$$w0rd1234"
  description = "Password for the VM OS"
  sensitive   = true
}

variable "image_version" {
  default     = "917.0.3"
  description = "Version of the ASAv"
}

variable "subnets" {
  default     = []
  description = "subnets for FTD interfaces"
}
