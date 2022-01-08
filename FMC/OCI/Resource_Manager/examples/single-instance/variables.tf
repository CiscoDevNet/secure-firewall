############################
#  Provider Configuration  #
############################
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



############################
#  VM Configuration        #
############################

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}


variable "multiple_ad" {
  type    = bool
  default = false
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "appliance_ips" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //8 cores
}

variable "hostname" {
  default     = "fmc"
  description = "FMC hostname"
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
  default     = ""
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