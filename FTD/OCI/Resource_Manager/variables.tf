############################
#  Provider Configuration  #
############################
variable "tenancy_ocid" {
  type = string
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the OCI region where resources will be created"
  type        = string
}

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

############################
#  VM Configuration        #
############################

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "ftd"
}

# variable "vm_ads_number" {
#   type        = list(number)
#   default     = [1]
#   description = "The Availability Domain Number for vm, OCI Availability Domains: 1,2,3  (subject to region availability)"
# }

variable "multiple_ad" {
  type    = bool
  default = false
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.8" //4 cores
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaamybyw5im3tfl5fimi3nd57no3mtczwenrll7fgkzi4zgbc32tlqa"
  description = "Marketplace Listing Image OCID"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
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
  default     = "cisco-ftd"
  description = "FTD hostname"
}




############################
#  Network Configuration (flattened)   #
############################
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


# variable "networks" {
#   type        = list(object({ name = string, vcn_cidr = string, subnet_cidr = string, private_ip = list(string), external_ip = bool }))
#   description = "a list of VPC network info"
#   default     = []
# }


variable "network_1_name" {

}

variable "network_1_vcn_cidr" {

}

variable "network_1_subnet_cidr" {

}

variable "network_1_private_ip" {
  type = list(string)
}


variable "network_1_external_ip" {

  type    = bool
  default = false
}

variable "network_2_name" {

}

variable "network_2_vcn_cidr" {

}

variable "network_2_subnet_cidr" {

}

variable "network_2_private_ip" {
  type = list(string)
}


variable "network_2_external_ip" {

  type    = bool
  default = false
}

variable "network_3_name" {

}

variable "network_3_vcn_cidr" {

}

variable "network_3_subnet_cidr" {

}

variable "network_3_private_ip" {
  type = list(string)
}


variable "network_3_external_ip" {

  type    = bool
  default = false
}
variable "network_4_name" {

}

variable "network_4_vcn_cidr" {

}

variable "network_4_subnet_cidr" {

}

variable "network_4_private_ip" {
  type = list(string)
}


variable "network_4_external_ip" {

  type    = bool
  default = false
}


variable "network_5_name" {
  default = ""
}

variable "network_5_vcn_cidr" {
  default = ""
}

variable "network_5_subnet_cidr" {
  default = ""
}

variable "network_5_private_ip" {
  type = list(string)
  default = []
}

variable "network_5_external_ip" {
  type    = bool
  default = false
}