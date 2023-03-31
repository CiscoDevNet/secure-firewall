variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
  default     = "FMC_RG"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
  default     = "East US"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET name in Azure"
  default     = "vnetprod01"
}

variable "subnet_name_1" {
  type        = string
  description = "Subnet 1 in Azure"
  default     = "subnet01"
}

variable "subnet_name_2" {
  type        = string
  description = "Subnet 2 in Azure"
  default     = "subnet02"
}

variable "subnet_name_3" {
  type        = string
  description = "Subnet 3 in Azure"
  default     = "subnet03"
}

variable "subnet_name_4" {
  type        = string
  description = "Subnet 4 in Azure"
  default     = "subnet04"
}

variable "public_ip_win" {
  type        = string
  description = "Public IP Win10 in Azure"
  default     = "publicip02"
}

variable "public_ip_ubuntu" {
  type        = string
  description = "Public IP OS in Azure"
  default     = "publicip01"
}

variable "public_ip_fmc" {
  type        = string
  description = "Public IP FMC in Azure"
  default     = "publicfmcip01"
}

variable "network_security_group_VM" {
  type        = string
  description = "NSG VM in Azure"
  default     = "nsgprod01"
}

variable "network_security_group_ALL" {
  type        = string
  description = "NSG Default in Azure"
  default     = "fmcprod01"
}

variable "network_interface_win" {
  type        = string
  description = "NIC Win10 in Azure"
  default     = "nicwin01"
}

variable "network_interface_name" {
  type        = string
  description = "NIC OS in Azure"
  default     = "nicprod01"
}

variable "network_interface_fmc" {
  type        = string
  description = "FMC NIC in Azure"
  default     = "fmcmgmt"
}

variable "linux_virtual_machine_name" {
  type        = string
  description = "Linux VM in Azure"
  default     = "fmcv01"
}

variable "fmc_virtual_machine_name" {
  type        = string
  description = "FMC in Azure"
  default     = "fmcmgmt"
}

variable "win_virtual_machine_name" {
  type        = string
  description = "Win10 in Azure"
  default     = "linuxvm01"
}

variable "fmc_version" {
  type        = string
  description = "Version of FMC in Azure"
  default     = "fmcv01"
}
#-----------------------------------------------------------
variable "virtual_machine_admin_username" {
  type        = string
  description = "Admin username virtual machines"
  default     = "ciscovm"
}

variable "virtual_machine_admin_passw" {
  type        = string
  description = "Virtual machines admin password"
  default     = "C!sco1234!"
}

variable "virtual_machine_fmcv_admin_passw" {
  type        = string
  description = "FMC vm admin password"
  default     = "123Cisco@123!"
}
