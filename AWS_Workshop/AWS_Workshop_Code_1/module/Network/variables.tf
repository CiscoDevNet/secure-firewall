#if vpc_cidr empty then use existing
variable "vpc_cidr" {
  default = ""
}

variable "vpc_name" {
  type    = string
  default = "IAC-VPC" 
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
  type = string
  default = ""
}

#provide default values for subnet name as it is used in both cases
variable "mgmt_subnet_name" {
  type    = list(string)
  default = ["mgmt1","mgmt2"]
}

variable "outside_subnet_name" {
  type    = list(string)
  default = ["outside1","outside2"]
}

variable "inside_subnet_name" {
  type    = list(string)
  default = ["inside1","inside2"]
}

variable "diag_subnet_name" {
  type    = list(string)
  default = ["diag1", "diag2"]
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "mgmt_interface" {
  type    = list(string)
  default = []
}

variable "outside_interface" {
  type    = list(string)
  default = []
}

variable "inside_interface" {
  type    = list(string)
  default = []
}

variable "diag_interface" {
  type    = list(string)
  default = []
}

variable "fmc_interface" {
  type    = string
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