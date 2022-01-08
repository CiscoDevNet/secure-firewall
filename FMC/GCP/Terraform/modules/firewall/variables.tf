variable "project_id" {
  description = "The project ID to host the network in"
}

variable "network" {
  type        = string
  default     = ""
  description = "The name of the VPC network for Vault."
}
variable "service_account" {
  type        = string
  description = "The email address of the service account which will be assigned to the compute instances."
}