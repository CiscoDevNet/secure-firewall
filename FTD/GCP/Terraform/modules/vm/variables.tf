variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}
variable "region" {
  type        = string
  description = "The region"
}

variable "networks_list" {
  type        = list(object({ name = string, network_self_link = string, subnet_self_link = string, subnet_cidr = string, appliance_ip = list(string), external_ip = bool, routes = list(string) }))
  description = "network links in a map(network_name)"
}
variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}
variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "vm_zones" {
  type        = list(string)
  description = "The zones"
}


variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
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
  default     = "cisco-ftdv-7-3-0-69"
}

variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}
variable "day_0_config_ftd" {
  type        = string
  description = "zero day configuration"
  default     = ""
}
variable "day_0_config_fmc" {
  type        = string
  description = "zero day configuration of fmc"
  default     = ""
}
variable "service_account" {
  description = "The email address of the service account which will be assigned to the compute instances."
  type        = string
}
variable "admin_password" {
  type        = string
  description = "password for ftd admin"
  sensitive   = true
}
variable "ftd_hostname" {
  default     = "ftd"
  description = "FTD hostname"
}
variable "fmc_hostname" {
  default     = "fmc"
  description = "FMC hostname"
}
variable "subnet_self_link_fmc" {
  description = "subnet self link of management network"
}
variable "network_project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}
variable "appliance_ips_fmc" {
  type        = list(string)
  description = "appliance IPs of management network"
}

variable "boot_disk_size" {
  description = "Root disk size in GB."
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

