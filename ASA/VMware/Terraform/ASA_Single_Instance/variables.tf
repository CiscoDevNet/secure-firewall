variable "userid" {
  description = "Login User ID"
  type        = string
}

variable "password" {
  description = "Login Password"
  type        = string
}

variable "vsphere_server" {
  description = "VCenter hostname or IP"
  type        = string
}


variable "datacenter" {
  description = "Datacenter name"
  type        = string
}

variable "datastore" {
  description = "Datastore name"
  type        = string
}

variable "cluster" {
  description = "Cluster name"
  type        = string
}

variable "host" {
  description = "Host IP/hostname"
  type        = string
}

variable "mgmt_network" {
  description = "Management interface network"
  type        = string
}

variable "inside_network" {
  description = "Inside interface network"
  type        = string
}

variable "outside_network" {
  description = "Outside interface network"
  type        = string
}

variable "hostname" {
  description = "ASAv Hostname"
  type        = string
  default     = "asav-terraform"
}

variable "ovf_path" {
  description = "Path to asav-vi.ovf"
  type        = string
}

variable "day0_config" {
  description = "Day0 Config file"
  type        = string
}
