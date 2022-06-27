
variable "vpc_service_id" {}
variable "vpc_spoke_id" {}
variable "spoke_subnet_id" {}

variable "tgw_subnet_name" {}

variable "tgw_subnet_cidr" {}

variable "vpc_spoke_cidr" {}

variable "availability_zone_count" {
  default = 2
}

variable "gwlbe" {
  type = list(string)
  description = "ID of the GWLB Endpoints"
}

variable "transit_gateway_name" {
  type = string
  description = "Name of the Transit Gateway created"
  default = null
}

variable "aws_availability_zones" {
  type = number
  default = 2
}

variable "NAT_Subnet_Routetable_IDs" {
  type = list(string)
  description = "list of Route table IDs associated with NAT Subnets"
  default = []
}

variable "GWLBE_Subnet_Routetable_IDs" {
  type = list(string)
  description = "list of Route table IDs associated with GWLBE Subnets"
  default = []
}
variable "service_subnet_cidr" {
  type = list(string)
  description = "CIDRs of the service TGW Subnet"
  default = []
}

variable "spoke_subnet_cidr" {
  description = "CIDRs for new spoke TGW subnets"
  type = list(string)
  default = []
}

variable "spoke_rt_id" {}
  