variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "tenancy_ocid" {
}

variable "vm_ads_number" {
  type        = list(number)
  default     = [1]
  description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "region" {
  type        = string
  description = "The region"
}

# variable "vm_ads" {
#   type        = list(string)
#   description = "The Availability Domain for vm"
# }

variable "instance_ids" {
  type        = list(string)
  description = "ocid of vm instances"
}

variable "service_port" {
  type        = number
  description = "service port"
}

variable "networks_map" {
  type        = map(object({ name = string, vcn_id = string, subnet_id = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
  description = "networks in a map(network_name)"
}

variable "outside_network" {
  type        = string
  description = "management network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = ""
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