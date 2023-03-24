#-------------------azure common Variables-------------#
variable "subscription_id" {
  description = ""
}

variable "tenant_id" {
  description = ""
}

variable "client_id" {
  description = ""
}

variable "client_secret" {
  description = ""
}

# --------------------resource group variables----------------------------#

variable "rg_name" {
  description = "Azure Resource Group"
}

variable "location" {
  description = "Geographic region resource will be deployed into"
  type        = string
}

variable "instances" {
  description = "Number of FTDv instances"
}



