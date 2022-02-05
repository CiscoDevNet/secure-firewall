variable "aws_access_key" {
  type    = string
  description = "AWS access key id"
}

variable "aws_secret_key" {
  type    = string
  description = "AWS secret key id"
}

variable "region" {
  type    = string
  description = "AWS region"
}

variable "vpc_service_id" {
  type = string
  description = "VPC ID of Service VPC"
}

variable "vpc_spoke_id" {
  type = string
  description = "VPC ID of Spoke VPC"
}

variable "subnet_service_name" {
  type = string
  description = "Name of the service TGW subnet being created"
  default = "Service-TGW-Subnet" 
}

variable "subnet_spoke_name" {
  type = string
  description = "Name of the spoke TGW subnet being created"
  default = "Spoke-TGW-Subnet"  
}

variable "cidr_spoke_sub" {
  description = "CIDRs for new spoke TGW subnets"
  type = list(string)
  default = []
}

variable "id_spoke_sub" {
  description = "IDs for existing spoke subnets"
  type = list(string)
  default = []
}

variable "cidr_service_sub" {
  type = list(string)
  description = "CIDRs of the service TGW Subnet"
}

variable "gwlbe" {
  type = list(string)
  description = "ID of the GWLB Endpoints"
}

variable "transit_gateway_name" {
  type = string
  description = "Name of the Transit Gateway created"
  default = "TGW"
}

variable "aws_availability_zones" {
  type = list(string)
  description = "List of AZs to distribute service subnets"
  default = ["ap-south-1a","ap-south-1b"]
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