variable "project_id" {
  description = "The project ID to host the network in"
}
variable "region" {
  description = "The region"
}

variable "networks" {
  type        = list(object({ name = string, cidr = string, appliance_ip = list(string), external_ip = bool }))
  description = "a list of VPC"
  default     = []
}

variable "mgmt_network" {
  type        = string
  description = "management network name"
}

variable "inside_network" {
  type        = string
  description = "inside network name"
}

variable "outside_network" {
  type        = string
  description = "outside network name"
}

variable "dmz_network" {
  type        = string
  description = "dmz network name"
}

variable "diag_network" {
  type        = string
  description = "diag network name"
}


variable "service_account" {
  type        = string
  description = "The email address of the service account which will be assigned to the compute instances."
}

variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
}

variable "appliance_ips_fmc" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for FMC"
}