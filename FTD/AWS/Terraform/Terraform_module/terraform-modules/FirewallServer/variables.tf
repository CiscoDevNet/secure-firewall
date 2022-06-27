variable "FTD_version" {
  description = "specified FTD version."
  type = string
  default = "ftdv-7.1.0"
}

variable "create_fmc" {
  description = "Boolean value to create FMC or not"
  type = bool
  default = true
}

variable "FMC_version" {
  description = "specified FMC version."
  type = string
  default = "fmcv-7.1.0"
}

variable "keyname" {
  description = "specified key pair name to connect firewall ."
  type = string
}

variable "instances_per_az" {
  description = "Spacified no. of instance per az wants to be create . "
  type    = number
  default = 1
}
variable "availability_zone_count" {
  description = "Spacified availablity zone count . "
  type    = number
  default = 2
}
variable "ftd_size" {
  description = "specified server instance type ."
  type = string
  default = "c5.4xlarge"
}
variable "fmc_mgmt_ip" {
  description = "specified fmc management IPs . "
  type    = string
  default = ""
}
variable "fmc_nat_id" {
  description = "specified fmc nat id . "
  type    = string
  default = ""
}
variable "ftd_mgmt_interface" {
  description = "list out ftd management interface ."
  type = list(string)
  default = []
}
variable "ftd_inside_interface" {
  description = "list out ftd inside interface ."
  type = list(string)
  default = []
}
variable "ftd_outside_interface" {
  description = "list out ftd outside interface ."
  type = list(string)
  default = []
}
variable "ftd_diag_interface" {
  description = "list out ftd digonstic interface ."
  type = list(string)
  default = []
}
variable "fmcmgmt_interface" {
  description = "spacified ftd management interface ."
  type = string
  default = ""
}

variable "tags" {
  description = "map the required tags ."
  type = map 
  default  = {}
}

variable "fmc_admin_password" {
  description = "spacified fmc admin password ."
  type = string
  default = "Cisco@123"
}

variable "fmc_hostname" {
  description = "spacified fmc hostname ."
  type = string
  default = "FMC-01"
}

variable "reg_key" {
  description = "spacified reg key ."
  type = string
  default = "cisco"
}

