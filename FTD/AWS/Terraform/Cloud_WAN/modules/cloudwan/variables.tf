# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "create_wan" {
  type    = bool
  default = true
}

variable "vpc_service_id" {
  type        = string
  description = "ID of the service VPC"
}

variable "wan_subnet_name" {
  type        = list(string)
  description = "List of name for wan Subnets"
  default     = []
}

variable "wan_subnet_cidr" {
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
  default     = null
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