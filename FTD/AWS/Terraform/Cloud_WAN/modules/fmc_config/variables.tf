variable "fmc_mgmt_ip" {
  description = "IP of you FMC"
  type        = string
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

variable "ftd_inside_ips" {
  type        = list(string)
  description = "List of Inside Interface IPs of FTD"
}

variable "ftd_outside_ips" {
  type        = list(string)
  description = "List of Outside Interface IPs of FTD"
}

variable "performance_tier" {
  type        = string
  description = "FTDv Performance Tier"
}

variable "ftd_version" {
  type        = string
  description = "FTDv Version"
}