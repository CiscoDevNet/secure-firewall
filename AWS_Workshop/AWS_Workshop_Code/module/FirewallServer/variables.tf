variable "FTD_version" {
  default = "ftdv-7.1.0"
}

variable "FMC_version" {
  default = "fmcv-7.1.0"
}

variable "keyname" {}

variable "instances_per_az" {
  default = 1
}
variable "availability_zone_count" {
  default = 2
}
variable "ftd_size" {
  default = "c5.4xlarge"
}
variable "fmc_mgmt_ip" {
  default = ""
}
variable "fmc_nat_id" {
  default = ""
}
variable "ftd_mgmt_interface" {}
variable "ftd_inside_interface" {}
variable "ftd_outside_interface" {}
variable "ftd_diag_interface" {}
variable "fmcmgmt_interface" {}
variable "tags" {
  type = map 
  default  = {}
}

variable "fmc_admin_password" {
  type = string
  default = "Cisco@123"
}

variable "fmc_hostname" {
  type = string
  default = "FMC-01"
}

variable "reg_key" {
  type = string
  default = "cisco"
}

