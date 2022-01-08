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


variable "networks" {
  type        = list(object({ name = string, vcn_cidr = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
  description = "a list of VPC"
  default     = []
}

variable "mgmt_network" {
  type        = string
  description = "management network name"
}

variable "inside_network" {
  type        = string
  description = "inside network name"
}

variable "outside_network" {
  type        = string
  description = "outside network name"
}

variable "dmz_network" {
  type        = string
  description = "dmz network name"
}

variable "diag_network" {
  type        = string
  description = "diag network name"
}

variable "tags" {
  description = "simple key-value pairs to tag the resources created"
  type        = map(any)
  default = {
    terraformed = "yes"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}
