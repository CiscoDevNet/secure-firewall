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

variable "use_existing_vpc" {
  type = bool
  description = "Setting to determine if GWLB needs to be created in a new or existing VPC"
}

variable "vpc_name" {
  type    = string
  description = "name for VPC"
}

variable "vpc_cidr" {
  type    = string
  description =  "VPC cidr block for new VPC"
  default = "172.16.0.0/16"
}

variable "igw_name" {
  type = string
  description = "Name of the Internet Gateway attached to Existing VPC"
  default = ""
}

variable "appliance_subnet" {
  type = list(string)
  description = "list of subnets for GWLB"
  default = []
}

variable "GWLB_name" {
  type    = string
  description = "name for Gateway loadbalancer"
  default = "GWLB"
}

variable "aws_availability_zones" {
  type    = list(string)
  description = "list of availability_zones"
  default = [ "us-east-1f", "us-east-1a" ]
}

variable "instance" {
  type    = list(string)
  description = "list of instance ip address that will be attached to target group of GWLB"
  default = []
}