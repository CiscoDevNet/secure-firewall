variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region"
}
variable "vm_zones" {
  type        = list(string)
  description = "The zones"
}
variable "service_port" {
  type        = number
  description = "service port"
}

variable "use_internal_lb" {
  type        = bool
  default     = false
  description = "use internal LB or not"
}

variable "allow_global_access" {
  type        = bool
  default     = false
  description = "Internal LB allow global access or not"
}

variable "networks_map" {
  type        = map(object({ name = string, network_self_link = string, subnet_self_link = string, subnet_cidr = string, appliance_ip = list(string), external_ip = bool, routes = list(string) }))
  description = "network links in a map(network_name)"
}

variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = ""
}

variable "named_ports" {
  description = "Named name and named port. https://cloud.google.com/load-balancing/docs/backend-service#named_ports"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
  # validation {
  #   condition     = var.num_instances <= 10
  #   error_message = "The num_instances value must be less than or equal to 10."
  # }
}

variable "instance_ids" {
  description = "a list of google_compute_instance id"
  type        = list(string)
  default     = []
}