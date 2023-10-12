# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "gwlbe_subnet_cidr" {
  description = "GWLB-Endpoint subnet CIDR"
  type        = list(string)
  default     = []
}

variable "gwlbe_subnet_name" {
  description = "GWLB-Endpoint subnet name"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "ID of the service VPC"
}

variable "ngw_id" {
  type        = list(string)
  description = "NAT GW Subnet ID"
  default = []
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID"
  default = ""
}

variable "gwlb" {
  type        = list(string)
  description = "Gateway Loadbalancer arn"
}

variable "spoke_rt_id" {
  type = list(string)
  default = []
}

variable "inbound" {
  type = bool
  default = false
}

variable "internet_gateway" {
  type = string
  default = ""
}

variable "spoke_subnet" {
  type = list(string)
  default = []
}
variable "pod_prefix"{
  type = string
  default = "Pod0"
}

variable "nat_gw"{
  type = list(string)
  default = null
}