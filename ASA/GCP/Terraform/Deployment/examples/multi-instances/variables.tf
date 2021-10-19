variable "project_id" {
  description = "The project ID to host the network in"
}
variable "region" {
  description = "The region"
}


variable "vm_zones" {
  type        = list(string)
  description = "The zones"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}

variable "networks" {
  type        = list(object({ name = string, cidr = string, appliance_ip = list(string), external_ip = bool }))
  description = "a list of VPC"
  default     = []
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
  default     = "cisco-asav-9-16-1-28"
}

variable "admin_ssh_pub_key" {
  description = "ssh public key for admin"
}

variable "enable_password" {
  type        = string
  description = "enable password for ASA zero day config"
}
variable "day_0_config" {
  description = "Render a startup script with a template."
  default     = ""
}
variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = ""
}
variable "outside_network" {
  type        = string
  description = "outside network name"
  default     = ""
}

variable "dmz1_network" {
  type        = string
  description = "dmz1 network name"
  default     = ""
}

variable "dmz2_network" {
  type        = string
  description = "dmz2 network name"
  default     = "vpc-dmz2"
}

variable "use_internal_lb" {
  type        = bool
  default     = false
  description = "use internal LB or not"
}

variable "allow_global_access" {
  type        = bool
  default     = false
  description = "Internal LB allow global access or not"
}
variable "service_port" {
  type        = number
  description = "service port"
  default     = 80
}