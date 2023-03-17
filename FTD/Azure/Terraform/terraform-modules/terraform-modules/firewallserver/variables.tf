variable "rg_name" {
  description = "resource group name"
  type        = string
}

variable "location" {
  type    = string
  description = "Spacified location vNet."
 }

variable "prefix" {
  default     = "cisco-FTDv"
  type        = string
  description = "Prefix to prepend resource names"
}

variable "instances" {
  description = "Number of FTDv instances"
  type    = string
  default = ""
}

variable "image_version" {
  default     = "67065.0.0"
  type    = string
  description = "Version of the FTDv"
}

variable "vm_size" {
  default = "Standard_D3_v2"
  type    = string
  description = "Spacify VM size"
}
variable "RGName" {
  default = "cisco-ftdv-RG"
  type    = string
}
variable "instancename" {
  type    = string
  default = "FTD01"
  description = "Spacify instance name"
}
variable "username" {
  type    = string
  default = "cisco"
  description = "Spacify username of FTDv server"
}
variable "password" {
  type    = string
  default = "P@$$w0rd1234"
  description = "Spacify username of FTDv server"
  sensitive = true
}

variable "azs" {
  type    = list
  default = [
    "1",
    "2",
    "3"
  ]
  
  description = "Azure Availability Zones"
}
variable "ftdv-interface-management" {
  type = list
  description = "ftdv interface management"
  default = []
}
variable "ftdv-interface-diagnostic" {
  type = list
  description = "ftdv interface diagnostic"
  default = []
}
variable "ftdv-interface-outside" {
  type = list
  description = "ftdv interface outside"
  default = []
}
variable "ftdv-interface-inside" {
  type = list
  description = "ftdv interface inside"
  default = []
}

