# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "create_tgw" {
  type = bool
  default = true
}

variable "vpc_service_id" {
  type        = string
  description = "ID of the service VPC"
}
variable "vpc_spoke_id" {
  type        = string
  description = "ID of the Spoke VPC"
}
variable "spoke_subnet_id" {
  type        = list(string)
  description = "ID of the Spoke Subnet"
  default = []
}
variable "vpc_spoke_cidr" {
  description = "Spoke VPC Subnet CIDR"
  type        = string
}
variable "spoke_rt_id" {
  type        = list(string)
  description = "Spoke VPC Route table ID"
}

variable "vpc_spoke_id_2" {
  type        = string
  description = "ID of the Spoke VPC"
}
variable "spoke_subnet_id_2" {
  type        = list(string)
  description = "ID of the Spoke Subnet"
  default = []
}
variable "vpc_spoke_cidr_2" {
  description = "Spoke VPC Subnet CIDR"
  type        = string
}
variable "spoke_rt_id_2" {
  type        = list(string)
  description = "Spoke VPC Route table ID"
}

variable "vpc_spoke_id_3" {
  type        = string
  description = "ID of the Spoke VPC"
}
variable "spoke_subnet_id_3" {
  type        = list(string)
  description = "ID of the Spoke Subnet"
  default = []
}
variable "vpc_spoke_cidr_3" {
  description = "Spoke VPC Subnet CIDR"
  type        = string
}
variable "spoke_rt_id_3" {
  type        = list(string)
  description = "Spoke VPC Route table ID"
}

variable "tgw_subnet_name" {
  type        = list(string)
  description = "List of name for TGW Subnets"
  default     = []
}

variable "tgw_subnet_cidr" {
  description = "Transit Gateway subnet CIDR"
  type        = list(string)
  default     = []
}

variable "availability_zone_count" {
  description = "Number of AZ to be used for deployment"
  type        = number
  default     = 2
}

variable "gwlbe" {
  type        = list(string)
  description = "ID of the GWLB Endpoints"
}

variable "transit_gateway_name" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = "tgw"
}

variable "nat_subnet_routetable_ids" {
  type        = list(string)
  description = "list of Route table IDs associated with NAT Subnets"
  default     = []
}

variable "gwlbe_subnet_routetable_ids" {
  type        = list(string)
  description = "list of Route table IDs associated with GWLBE Subnets"
  default     = []
}

variable "tgw_appliance_mode"{
  type = string
  default = "enable"
}
variable "pod_prefix"{
  type = string
  default = "Pod0"
}