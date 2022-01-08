variable "tenancy_ocid" {
}
variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}
variable "region" {
  type        = string
  description = "The region"
}

variable "multiple_ad" {
  type    = bool
  default = false
}

# variable "vm_ads_number" {
#   type        = list(number)
#   default     = [1]
#   description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
# }

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
  # validation {
  #   condition     = var.num_instances <= 2
  #   error_message = "The num_instances value must be less than or equal to 2."
  # }
}

variable "subnet_id" {
  description = "existing subnet id for managment network's subnet"
  default     = ""
}
variable "appliance_ips" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}

variable "mp_listing_resource_id" {
  default     = ""
  description = "Marketplace Listing Image OCID"
}

variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}

variable "admin_password" {
  type        = string
  description = "enable password for zero day config"
}

variable "day_0_config" {
  type        = string
  description = "zero day configuration"
  default     = ""
}

variable "hostname" {
  default     = "fmc"
  description = "FMC hostname"
}