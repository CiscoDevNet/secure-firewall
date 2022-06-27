variable "gwlbe_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "gwlbe_subnet_name" {
  type    = list(string)
  default = []
}

variable "vpc_id" {}

variable "ngw_id" {}

variable "gwlb" {}

variable "availability_zone_count" {
  default = 2
}