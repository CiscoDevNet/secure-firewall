############################
#  Provider Configuration   #
############################
variable "tenancy_ocid" {
}


variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the OCI region where resources will be created"
  type        = string
  #default     = null
}

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

############################
#  VM Configuration   #
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

variable "multiple_ad" {
  type    = bool
  default = false
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}
variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaarhp3ouzhmequs7a7462ro6rdqaxwz7ddizibfxs2tgaxqe6upv7q"
  description = "Marketplace Listing Image OCID"
}

variable "day_0_config" {
  type        = string
  description = "Render a startup script with a template."
  default     = "fmcv.txt"
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
  default     = "fmc"
  description = "FMC hostname"
}



############################
#  Network Configuration   #
############################

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "subnet_id" {
  description = "existing subnet id for managment network's subnet"
  default     = ""
}

variable "mangement_vcn_display_name" {
  description = "management VCN Name"
  default     = "mgmt"
}

variable "mangement_vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.22.0.0/16"
}

variable "mangement_subnet_cidr_block" {
  description = "Management Subnet CIDR"
  default     = "10.22.0.0/24"
}

variable "appliance_ips" {
  type        = list(string)
  default     = ["10.22.0.10"]
  description = "internal IP addresses for cisco appliance"
}


######################
#    Enum Values     #   
######################
variable "network_strategy_enum" {
  type = map(any)
  default = {
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}