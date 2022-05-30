
variable "aws_access_key" {}
 
variable "aws_secret_key" {}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "Transit-Service-VPC1"
}

variable "vpc_cidr" {
  default = ""
}

variable "create_igw" {
  type    = bool
  default = false
}

variable "availability_zone_count" {
  default = 2
}

variable "instances_per_az" {
  default = 1
}

#if subnet cidr empty then use existing based on subnet name
variable "mgmt_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_mgmt_ip" {
  default = []
}

variable "outside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_outside_ip" {
  default = []
}

variable "diag_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_diag_ip" {
  default = []
}

variable "inside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_inside_ip" {
  default = []
}

variable "fmc_ip" {
  default = ""
}

variable "mgmt_subnet_name" {
  type    = list(string)
  default = []
}

variable "outside_subnet_name" {
  type    = list(string)
  default = []
}

variable "inside_subnet_name" {
  type    = list(string)
  default = []
}

variable "diag_subnet_name" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "mgmt_interface_id" {
  type    = list(string)
  default = []
}

variable "outside_interface_id" {
  type    = list(string)
  default = []
}

variable "inside_interface_id" {
  type    = list(string)
  default = []
}

variable "diag_interface_id" {
  type    = list(string)
  default = []
}

variable "fmc_interface_id" {
  type    = string
  default = ""
}

variable "FTD_version" {
  type = string
  default = "ftdv-7.1.0"
}

variable "FMC_version" {
  type = string
  default = "fmcv-7.1.0"
}

variable "keyname" {
  type = string
}

variable "ftd_size" {
  default = "c5.xlarge"
}

variable "external_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 80
    target_type = "ip"
  }]
}

variable "internal_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 80
    target_type = "ip"
  }
  ]
}

#list the possible options as allowed values
variable "create"{
  type = string
  default = "both"
}

variable "internal_health_check" {
  default = {
    protocol = "TCP"
    port     = 22
  }
}

variable "external_health_check" {
  default = {
    protocol = "TCP"
    port     = 22
  }
}

variable "app_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "app_subnet_name" {
  type    = list(string)
  default = []
}

variable "ftd_app_ip" {
  default = []
}

variable "app_interface" {
  default = []
}

variable "bastion_subnet_cidr" {
  type    = string
  default = ""
}

variable "bastion_ip" {
  default = ""
}

variable "bastion_subnet_name" {
  default = ""
}

variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "fmc_mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "bastion_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "app_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
