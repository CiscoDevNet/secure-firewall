############################
#  Provider Configuration  #
############################
variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

# The contents of the private key file. Required if private_key_path is not defined, and takes precedence over private_key_path if both are defined.
variable "private_key" {
}
variable "private_key_path" {
}


variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the OCI region where resources will be created"
  type        = string
  default     = null
}

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

############################
#  VM Configuration        #
############################

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}
variable "vm_ads_number" {
  type        = list(number)
  default     = [1]
  description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}
variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaamybyw5im3tfl5fimi3nd57no3mtczwenrll7fgkzi4zgbc32tlqa"
  description = "Marketplace Listing Image OCID"
}


variable "day_0_config" {
  type        = string
  description = "Render a startup script with a template."
  default     = "startup_file.json"
}
variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}


variable "admin_password" {
  type        = string
  description = "password for admin"
  sensitive   = true
}

variable "hostname" {
  default     = "ftd"
  description = "FTD hostname"
}

############################
#  Network Configuration   #
############################

variable "networks" {
  type        = list(object({ name = string, vcn_cidr = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
  description = "a list of VPC network info"
  default     = []
}


variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}
variable "diag_network" {
  type        = string
  description = "diag network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = "vpc-inside"
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

