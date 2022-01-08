variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "region" {
  description = "The region"
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

############################
#  Network Configuration   #
############################

variable "mangement_vcn_display_name" {
  description = "management VCN Name"
  default     = "mgmt"
}

variable "mangement_vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.22.0.0/16"
}

variable "mangement_subnet_cidr_block" {
  description = "Management Subnet CIDR"
  default     = "10.22.0.0/24"
}

variable "appliance_ips" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
}

variable "tags" {
  description = "simple key-value pairs to tag the resources created"
  type        = map(any)
  default = {
    terraformed = "yes"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}
