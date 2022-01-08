variable "project_id" {
  description = "The project ID to host the network in"
}
variable "region" {
  description = "The region"
}
variable "network" {
  type        = string
  default     = ""
  description = "The name of the VPC network for Vault."
}

variable "network_subnet_cidr_range" {
  type    = string
  default = "10.127.0.0/24"

  description = "CIDR block range for the subnet."
}

# variable "service_account" {
#   type        = string
#   description = "The email address of the service account which will be assigned to the compute instances."
# }

variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
}

variable "appliance_ips" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
}