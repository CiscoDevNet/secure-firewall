variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
  description = "The region"
}

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "networks" {
  type        = list(object({ name = string, vcn_cidr = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
  description = "a list of VPC"
  default     = []
}


variable "vm_ads_number" {
  type        = list(number)
  default     = [1]
  description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //8 cores
}

variable "hostname" {
  default     = "ftd"
  description = "FTD hostname"
}

variable "admin_password" {
  type        = string
  description = "password for admin"
  sensitive   = true
}

variable "admin_ssh_pub_key" {
  description = "ssh public key for admin"
}


variable "day_0_config" {
  type        = string
  description = "Render a startup script with a template."
  default     = "startup_file.json"
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
variable "outside_network" {
  type        = string
  description = "outside network name"
  default     = ""
}

variable "dmz_network" {
  type        = string
  description = "dmz network name"
  default     = ""
}

variable "diag_network" {
  type        = string
  description = "diag network name"
  default     = ""
}
