
################################################################################################
### resource group variables
################################################################################################

variable "create_rg" {
  default     = true
  type        = string
  description = "Wheather to create Resource Group"
}

variable "rg_name" {
  description = "Azure Resource Group"
  type = string
  default = ""
}

variable "location" {
  description = "Geographic region resource will be deployed into"
  type        = string
  default     = ""
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)
  default = {
    ENV = "Dev"
  }
}
