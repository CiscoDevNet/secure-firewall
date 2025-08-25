# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "vpc_cidr" {
  description = "Specified CIDR for VPC . "
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Specified VPC Name . "
  type        = string
  default     = "IAC-VPC"
}

variable "create_igw" {
  description = "Condition to create IGW"
  type        = bool
  default     = false
}

variable "igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "availability_zone_count" {
  description = "Spacified availablity zone count . "
  type        = number
  default     = 2
}

variable "instances_per_az" {
  description = "Spacified no. of instance per az wants to be create . "
  type        = number
  default     = 1
}
variable "tags" {
  description = "tags to map with resources ."
  type        = map(any)
  default     = {}
}


variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = false
}

variable "rta" {
  description = "Route table association for the outside subnet"
  type        = bool
  default     = true
}

variable "prefix" {
  description = "Prefix added to the resources created"
  type        = string
  default     = ""
}

variable "ftd_count" {
  description = "Number of FTDs to be deployed"
  type        = number
}