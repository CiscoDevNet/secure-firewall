variable "ASA_version" {
  default = "asav9-19-1"
}

variable "keyname" {}

variable "instances_per_az" {
  default = 2
}

variable "availability_zone_count" {
  default = 2
}

variable "asa_size" {
  default = "c5.2xlarge"
}

variable "asa_mgmt_interface" {
  type    = list(string)
}

variable "asa_inside_interface" {
  type    = list(string)
}

variable "asa_outside_interface" {
  type    = list(string)
}

variable "asa_dmz_interface" {
  type    = list(string)
}

variable "tags" {
  type = map 
  default  = {}
}