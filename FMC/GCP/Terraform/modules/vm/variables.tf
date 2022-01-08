variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}
variable "region" {
  type        = string
  description = "The region"
}
variable "network_project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}

variable "subnet_self_link" {
  description = "subnet self link of management network"
}

variable "appliance_ips" {
  type        = list(string)
  description = "appliance IPs of management network"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "hostname" {
  default     = "fmc"
  description = "FMCv OS hostname"
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
  default     = "cisco-fmcv-7-0-0-94"
}

variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}
variable "day_0_config" {
  type        = string
  description = "zero day configuration"
  default     = ""
}

variable "admin_password" {
  type        = string
  description = "password for fmc admin"
  sensitive   = true
}


variable "service_account" {
  description = "The email address of the service account which will be assigned to the compute instances."
  type        = string
}

variable "boot_disk_size" {
  description = "Root disk size in GB."
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}
