variable "devnet_pod" {
    type = string
    default = ""
}

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

variable "fmc_domain" {
    type = string
}

variable "ftd_hostname" {
    type = string
}

variable "ftd_registration_key" {
    type = string
    default = ""
}

variable "insCount" {
    default = 2
}

variable "fmc_insecure_skip_verify" {
    type = bool
    default = true
}
variable "ftd_ips" {
  type    = string
}

/*
variable "inside_gw_ips" {
  type    = string
}*/