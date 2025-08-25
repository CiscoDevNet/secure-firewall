# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "availability_zone_count" {
  default = 2
}

variable "vpc_id" {
  type        = string
  description = "ID of the service VPC"
}

variable "ngw_id" {
  type        = list(string)
  description = "NAT GW Subnet ID"
  default     = []
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID"
  default     = ""
}

variable "gwlb" {
  type        = list(string)
  description = "Gateway Loadbalancer arn"
}
variable "inbound" {
  type    = bool
  default = false
}

variable "internet_gateway" {
  type    = string
  default = ""
}

variable "spoke_subnet" {
  type    = list(string)
  default = []
}

variable "prefix" {
  description = "Prefix added to the resources created"
  type        = string
  default     = ""
}

variable "service_vpc_cidr" {
  type        = string
  description = "Service VPC CIDR"
  default     = null
}