variable "fmc_mgmt_ip" {
  description = "IP of you FMC"
  type        = string
}

variable "fmc_username" {
  type        = string
  description = "FMC username"
  default     = "admin"
}

variable "fmc_password" {
  type        = string
  description = "FMC admin password"
}

variable "fmc_insecure_skip_verify" {
  type        = bool
  description = "Condition to verify FMC certificate"
  default     = true
}

variable "inscount" {
  type        = number
  description = "FTD instance count"
  default     = 2
}

variable "reg_key" {
  type        = string
  description = "Registration key"
}

variable "fmc_nat_id" {
  type        = string
  description = "FMC Registration NAT ID"
  default     = ""
}

variable "ftd_mgmt_ips" {
  description = "FTD Management IPs"
  type        = list(string)
}

variable "instance_names" {
  description = "FTD Instance Names"
  type        = list(string)
}

variable "access_policy_id" {
  type        = string
  description = "Access Policy ID"
}

variable "access_policy_type" {
  type        = string
  description = "Access Policy Type"
}

variable "performance_tier" {
  type        = string
  description = "FTDv Performance Tier"
}