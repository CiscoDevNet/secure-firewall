variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "datacenter" {
  description = "vSphere data center"
  type        = string
}

variable "datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "cpu" {
  default     = "4"
  description = "FTDv number pf CPUs"
  type        = string
}

variable "memory" {
  default     = "8192"
  description = "FTDv memory allocation"
  type        = string
}

variable "network_name1" {
  description = "vSphere network name"
  type        = string
}

variable "network_name2" {
  description = "vSphere network name"
  type        = string
}

variable "network_name3" {
  description = "vSphere network name"
  type        = string
}

variable "network_name4" {
  description = "vSphere network name"
  type        = string
}

variable "resource_pool" {
  description = "vSphere resource_pool name"
  type        = string
}

variable "host" {
  description = "vSphere host name"
  type        = string
}

variable "password" {
  description = "Admin user password"
  type        = string
  sensitive   = true
}

variable "hostname" {
  description = "FTDv hostname"
  type        = string
}

variable "dns1" {
  default     = ""
  description = "Primary DNS Server"
  type        = string
}

variable "dns2" {
  default     = ""
  description = "Secondary DNS Server"
  type        = string
}

variable "dns3" {
  default     = ""
  description = "Tertiary DNS Server"
  type        = string
}

variable "searchdomains" {
  default     = ""
  description = "DNS Search Domains"
  type        = string
}

#mgmt_ip4_config can be Disabled, Manual or DHCP
variable "mgmt_ip4_config" {
  default     = "Manual"
  description = "Management IPv4 Configuration"
  type        = string
}

variable "mgmt_ip4" {
  default     = ""
  description = "Management IPv4 Address"
  type        = string
}

variable "mgmt_ip4_mask" {
  default     = ""
  description = "Management IPv4 Mask"
  type        = string
}

variable "mgmt_ip4_gateway" {
  default     = ""
  description = "Management IPv4 Gateway"
  type        = string
}

#mgmt_ip6_config can be Disabled, Manual or DHCP
variable "mgmt_ip6_config" {
  default     = "Disabled"
  description = "Management IPv6 Configuration"
  type        = string
}

variable "mgmt_ip6" {
  default     = ""
  description = "Management IPv6 Address"
  type        = string
}

variable "mgmt_ip6_mask" {
  default     = ""
  description = "Management IPv6 Mask"
  type        = string
}

variable "mgmt_ip6_gateway" {
  default     = ""
  description = "Management IPv6 Gateway"
  type        = string
}

#local_manager value can be Yes or No
variable "local_manager" {
  default = "Yes"
  description = "Enabled Manager locally"
  type        = string
}

#firewall mode value can be routed or transparent
variable "firewall_mode" {
  default     = "routed"
  description = "Firewall Mode"
  type        = string
}

variable "fmc_ip" {
  default = ""
  description = "Managing FMC IP"
  type        = string
}

variable "fmc_regkey" {
  default = ""
  description = "FMC Registration key"
  type        = string
}

variable "fmc_nat_id" {
  default = ""
  description = "FMC NAT ID"
  type        = string
}