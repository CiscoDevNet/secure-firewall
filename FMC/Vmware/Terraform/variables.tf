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

variable "network_name" {
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
  default     = ""
  description = "Admin user password"
  type        = string
  sensitive   = true
}

variable "hostname" {
  default     = "fmc"
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

variable "ntp1" {
  default     = ""
  description = "Primary NTP Server"
  type        = string
}

variable "ntp2" {
  default     = ""
  description = "Secondary NTP Server"
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
