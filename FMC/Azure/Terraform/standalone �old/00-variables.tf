variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "virtual_network_name" {
  type        = string
  description = "VNET name in Azure"
}

variable "subnet_name_1" {
  type        = string
  description = "Subnet 1 in Azure"
}

variable "subnet_name_2" {
  type        = string
  description = "Subnet 2 in Azure"
}

variable "subnet_name_3" {
  type        = string
  description = "Subnet 3 in Azure"
}

variable "subnet_name_4" {
  type        = string
  description = "Subnet 4 in Azure"
}

variable "public_ip_win" {
  type        = string
  description = "Public IP Win10 in Azure"
}

variable "public_ip_ubuntu" {
  type        = string
  description = "Public IP OS in Azure"
}

variable "public_ip_fmc" {
  type        = string
  description = "Public IP FMC in Azure"
}

variable "network_security_group_VM" {
  type        = string
  description = "NSG VM in Azure"
}

variable "network_security_group_ALL" {
  type        = string
  description = "NSG Default in Azure"
}

variable "network_interface_win" {
  type        = string
  description = "NIC Win10 in Azure"
}

variable "network_interface_name" {
  type        = string
  description = "NIC OS in Azure"
}

variable "network_interface_fmc" {
  type        = string
  description = "FMC NIC in Azure"
}

variable "linux_virtual_machine_name" {
  type        = string
  description = "Linux VM in Azure"
}

variable "fmc_virtual_machine_name" {
  type        = string
  description = "FMC in Azure"
}

variable "win_virtual_machine_name" {
  type        = string
  description = "Win10 in Azure"
}
variable "fmc_version" {
  type        = string
  description = "Version of FMC in Azure"
}