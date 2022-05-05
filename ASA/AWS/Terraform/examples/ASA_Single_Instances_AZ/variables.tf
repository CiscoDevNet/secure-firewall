// defining the subnets variables with the default value for Three Tier Architecure. 

variable "aws_access_key" {}
 
variable "aws_secret_key" {}

variable "vpc_cidr" {
  default = null
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "mgmt_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "asa_mgmt_ip" {
  default = []
}

variable "outside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "asa_outside_ip" {
  default = []

}

variable "dmz_subnet_cidr" {
  type    = list(string)
  default = []
}


variable "asa_dmz_ip" {
  default = []
}


variable "inside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "asa_inside_ip" {
  default = []
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

variable "inside_subnet_name" {
  type    = list(string)
  default = []
}

variable "dmz_subnet_name" {
  type    = list(string)
  default = []
}

variable "vpc_name" {
  type    = string
  default = null
}

variable "create_igw" {
  type    = string
  default = true
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
variable "inside_interface_id" {
  type    = list(string)
  default = []
}
variable "dmz_interface_id" {
  type    = list(string)
  default = []
}

variable "instances_per_az" {
  default = 1
}

variable "asa_size" {
  default = "c5.2xlarge"
}

variable "keyname" {}