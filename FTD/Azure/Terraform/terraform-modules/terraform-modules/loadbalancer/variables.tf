variable "instances" {
  description = "Number of FTDv instances"
  type = number
}

variable "rg_name" {
  description = "resource group name"
  type        = string
}

variable "location" {
  type    = string
  description = "Spacified location of LB."
 }

variable "subnet_id" {
  description = "Spacified private subnet."
 }

 variable "private_ip_address_ext" {
  description = "External Private ip address to assign to frontend. Use it with type = private"
   type = list
  
}

 variable "private_ip_address_int" {
  description = "internal Private ip address to assign to frontend. Use it with type = private"
   type = list
  
}

 variable "virtual_network_id" {
  description = "Spacified Vnet ID"
  type        = string
}

variable "get_private_ip_address" {
  description = "private address"
  type        = string
}
