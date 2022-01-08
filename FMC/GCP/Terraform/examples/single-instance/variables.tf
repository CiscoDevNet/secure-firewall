variable "project_id" {
  description = "The project ID to host the network in"
}
variable "region" {
  description = "The region"
}

# variable "networks" {
#   type        = list(object({ name = string, cidr = string }))
#   description = "a list of VPC"
#   default     = []
# }


variable "network" {
  type        = string
  default     = ""
  description = "The name of the VPC network for Vault."
}

variable "subnet" {
  type        = string
  default     = ""
  description = "The name of the VPC subnetwork for Vault. By default, one will be created for you."
}

variable "network_subnet_cidr_range" {
  type    = string
  default = "10.127.0.0/24"

  description = "CIDR block range for the subnet."
}

variable "appliance_ips" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
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
  description = "cisco product version"
  default     = "cisco-fmcv-7-0-0-94"
}

variable "admin_ssh_pub_key" {
  description = "ssh public key for admin"
}
variable "day_0_config" {
  description = "Render a startup script with a template."
  default     = ""
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  description = "The GCE boot disk type.Set to pd-standard (for PD HDD)."
}
variable "admin_password" {
  type        = string
  description = "password for admin"
  sensitive   = true
}