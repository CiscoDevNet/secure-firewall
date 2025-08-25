variable "inside_gateway" {
  type = list(string)
}

variable "outside_gateway" {
  type = list(string)
}

variable "app_lb" {
  type = list(string)
}

variable "fmc_admin_password" {
  type = string
  default = "Cisco@123"
}

variable "elb" {
  type = list(string)
}

variable "fmc_insecure_skip_verify" {
  type = bool
  default = true
}

variable "fmc_ip" {
  description = "FMCv IP"
  type        = string
  default     = ""
}

variable "ftd_app_subnet" {
  type = list(string)
}

variable "ftd_mgmt_ip" {
  type = list(string)
}