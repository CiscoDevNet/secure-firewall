# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

variable "gwlb_name" {
  type        = string
  description = "name for Gateway loadbalancer"
}

variable "instance_ip" {
  type        = list(string)
  description = "list of instance ip address that will be attached to target group of GWLB"
  default     = []
}

variable "gwlb_subnet" {
  type        = list(string)
  description = "GWLB subnet"
}

variable "gwlb_vpc_id" {
  type        = string
  description = "GWLB vpc id"
}
variable "pod_prefix"{
  type = string
  default = "Pod0"
}


