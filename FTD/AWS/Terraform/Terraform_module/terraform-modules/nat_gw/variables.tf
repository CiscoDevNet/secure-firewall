variable "ngw_subnet_cidr" {
  description = "Spacified ngw subnet CIDR   ."
  type    = list(string)
  default = []
}

variable "ngw_subnet_name" {
  description = "Spacified ngw subnet name ."
  type    = list(string)
  default = []
}

variable "availability_zone_count" {
  description = "Spacified availablity zone count . "
  type    = number
  default = 2
}

variable "vpc_id" {
  description = "Specified VPC ID . "
  type    = string
  default = ""
}
 