############################
#  Provider Configuration  #
############################
variable "project_services" {
  type = list(string)

  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]

  description = "List of services to enable on the project where Vault will run. These services are required in order for this Vault setup to function."
}
variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region"
}



############################
#  VM Configuration        #
############################

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}
variable "vm_zones" {
  type        = list(string)
  description = "The zones of vm instances"
}
variable "vm_machine_type" {
  type        = string
  description = "machine type for appliance"
  default     = "e2-standard-4"
}

variable "vm_instance_labels" {
  type    = map(string)
  default = {}

  description = "Labels to apply to the vm instances."
}

variable "vm_instance_tags" {
  type    = list(string)
  default = []

  description = "Additional tags to apply to the instances, please note the service account is used as much as possible as best practice"
}

variable "cisco_product_version" {
  type        = string
  description = "cisco product version"
  default     = "cisco-ftdv-7-0-0-94"
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

variable "day_0_config" {
  type        = string
  description = "Render a startup script with a template."
  default     = "startup_file.json"
}

variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}

############################
#  Network Configuration   #
############################

variable "networks" {
  type        = list(object({ name = string, cidr = string, appliance_ip = list(string), external_ip = bool }))
  description = "a list of VPC network info"
  default     = []
}

variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}

variable "outside_network" {
  type        = string
  description = "outside network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = "vpc-inside"
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

variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
  default     = "cisco-ftd"
}