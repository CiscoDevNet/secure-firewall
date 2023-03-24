variable "sa_account_id" {
  type        = string
  description = "service account id"
  default     = "terraform-managed-sa"
}

variable "sa_display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed-sa"
}
variable "sa_description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = "Temp SA for terraform"
}
