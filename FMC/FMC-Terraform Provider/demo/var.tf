variable "fmc_username" {
    type = string
}

variable "fmc_password" {
    type = string
    sensitive = true
}

variable "fmc_host" {
    type = string
}

variable "insCount" {
    default = 2
}

variable "fmc_insecure_skip_verify" {
    type = bool
    default = true
}
variable "ftd_ips" {
  type    = list(string)
  default = []
}

variable "inside_gw_ips" {
  type    = list(string)
  default = []
}