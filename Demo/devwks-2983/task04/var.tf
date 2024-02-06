variable "devnet_pod" {
    type = string
}

variable "fmc_username" {
    type = string
}

variable "fmc_domain" {
    type = string
}

variable "fmc_password" {
    type = string
    sensitive = true
}

variable "fmc_host" {
    type = string
}

variable "ftd_name" {
    type = string
}

variable "fmc_insecure_skip_verify" {
    type = bool
    default = true
}

variable "inside_gw_ips" {
  type    = string
}

variable "ftd_hostname" {
    type = string
}

variable "ftd_ips" {
    type = string
}
