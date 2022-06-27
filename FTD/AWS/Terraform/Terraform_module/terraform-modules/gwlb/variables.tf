variable "GWLB_name" {
  type    = string
  description = "name for Gateway loadbalancer"
 }

variable "availability_zone_count" {
  default = 2
}

variable "instance_ip" {
  type    = list(string)
  description = "list of instance ip address that will be attached to target group of GWLB"
  default =  []
}

variable "gwlb_subnet" {
  type    = string
  description = "GWLB subnet"
 }

variable "gwlb_vpc_id" {
  type    = string
  description = "GWLB vpc id"
}


