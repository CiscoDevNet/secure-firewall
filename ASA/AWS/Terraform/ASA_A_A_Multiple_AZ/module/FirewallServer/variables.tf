variable "ASA_version" {
  default = "asav9-15-1"
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

variable "instance_count" {
  default = 2
}

variable "asa_mgmt_interface" {}

variable "asa_inside_interface" {}

variable "asa_outside_interface" {}

variable "asa_dmz_interface" {}