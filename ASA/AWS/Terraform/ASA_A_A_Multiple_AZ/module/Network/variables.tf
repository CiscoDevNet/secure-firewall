// defining the subnets variables with the default value for Three Tier Architecure. 



variable "vpc_cidr" {
  default = null
}

variable "mgmt01_subnet_cidr" {
  default = null
}

variable "mgmt02_subnet_cidr" {
  default = null
}

variable "asa01_mgmt_ip" {
  default = "10.0.1.10"
}

variable "asa02_mgmt_ip" {
  default = "10.0.10.20"
}

variable "outside01_subnet_cidr" {
  default = null
}

variable "outside02_subnet_cidr" {
  default = null
}

variable "asa01_outside_ip" {
  default = "10.0.5.10"

}

variable "asa02_outside_ip" {
  default = "10.0.50.20"
}

variable "dmz01_subnet_cidr" {
  default = null
}

variable "dmz02_subnet_cidr" {
  default = null
}

variable "asa01_dmz_ip" {
  default = "10.0.4.10"
}

variable "asa02_dmz_ip" {
  default = "10.0.40.20"
}

variable "inside01_subnet_cidr" {
  default = null
}

variable "inside02_subnet_cidr" {
  default = null
}

variable "asa01_inside_ip" {
  default = "10.0.3.10"
}

variable "asa02_inside_ip" {
  default = "10.0.30.20"
}


variable "availability_zone_count" {
  default = 2
}


variable "mgmt01_subnet_name" {
  type    = string
  default = "mgmt01"
}

variable "mgmt02_subnet_name" {
  type    = string
  default = "mgmt02"
}

variable "outside01_subnet_name" {
  type    = string
  default = "outside01"
}

variable "outside02_subnet_name" {
  type    = string
  default = "outside02"
}

variable "inside01_subnet_name" {
  type    = string
  default = "inside01"
}

variable "inside02_subnet_name" {
  type    = string
  default = "inside02"
}

variable "dmz01_subnet_name" {
  type    = string
  default = "dmz01"
}

variable "dmz02_subnet_name" {
  type    = string
  default = "dmz02"
}

variable "vpc_name" {
  type    = string
  default = "newvpc"
}