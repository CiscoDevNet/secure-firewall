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

variable "dmz1_network" {
  type        = string
  description = "dmz1 network name"
}

variable "dmz2_network" {
  type        = string
  description = "dmz2 network name"
}


variable "service_account" {
  type        = string
  description = "The email address of the service account which will be assigned to the compute instances."
}

variable "service_port" {
  type        = number
  description = "service port"
}

variable "ha_enabled" {
  type        = bool
  description = "HA enabled"
  default     = false
}
variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
}