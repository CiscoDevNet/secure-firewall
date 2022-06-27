variable "aws_access_key" {} 
variable "aws_secret_key" {}
variable "region" {
  type = string
  default = "us-east-1"
}

variable "service_vpc_cidr" {
  default = null
}

variable "service_vpc_name" {
  type    = string
  default = null
}

variable "service_create_igw" {
  type    = bool
  default = false
}

variable "service_subnet_cidr" {
    type    = list(string)
  default = []
}

variable "subnet_service_name" {
  type    = list(string)
  default = []
}

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

variable "fmc_ip" {
  type = string
  default = ""
}

variable "availability_zone_count" {
  default = 2
}

variable "mgmt_subnet_name" {
  type    = list(string)
  default = []
}

variable "outside_subnet_name" {
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

variable "security_group_ingress_with_cidr" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = null
  }]
}


variable "security_group_egress" {
  description = "Can be specified multiple times for each egress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["10.0.0.0/8"]
    description = null
  }]
}

variable "mgmt_interface_id" {
  type    = list(string)
  default = []
}

variable "outside_interface_id" {
  type    = list(string)
  default = []
}

variable "diag_interface_id" {
  type    = list(string)
  default = []
}

variable "instances_per_az" {
  default = 1
}

variable "gwlbe_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "gwlbe_subnet_name" {
  type    = list(string)
  default = []
}

variable "ngw_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ngw_subnet_name" {
  type    = list(string)
  default = []
}

########################################################################
## Instances
########################################################################

variable "ftd_size" {
  default = "c5.xlarge"
}

variable "keyname" {}

########################################################################
## GatewayLoadbalncer 
########################################################################

variable "GWLB_name" {
  type    = string
  description = "name for Gateway loadbalancer"
 }

variable "aws_availability_zones" {
  type    = list(string)
  description = "list of availability_zones"
  default = []
}

variable "instance_ip" {
  type    = list(string)
  description = "list of instance ip address that will be attached to target group of GWLB"
  default =  []
}

variable "inside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_inside_ip" {
  default = []
}

variable "inside_subnet_name" {
  type    = list(string)
  default = []
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