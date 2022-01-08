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

variable "vm_ads_number" {
  type        = list(number)
  default     = [1]
  description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "networks_list" {
  type        = list(object({ name = string, vcn_id = string, subnet_id = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
  description = "network links in a map(network_name)"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
  # validation {
  #   condition     = var.num_instances <= 2
  #   error_message = "The num_instances value must be less than or equal to 2."
  # }
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaamybyw5im3tfl5fimi3nd57no3mtczwenrll7fgkzi4zgbc32tlqa"
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
  default     = "ftd"
  description = "FTD hostname"
}