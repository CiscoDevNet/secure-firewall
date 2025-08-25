
variable "external_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 80
    target_type = "ip"
  }]
}

variable "internal_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 80
    target_type = "ip"
  }
  ]
}

#list the possible options as allowed values
variable "create"{
  type = string
  default = "both"
}

variable "internal_health_check" {
  default = {
    protocol = "TCP"
    port     = 80
  }
}

variable "external_health_check" {
  default = {
    protocol = "TCP"
    port     = 22
  }
}

variable "vpc_id" {}

variable "ftd_inside_ip" {
  default = []
}
variable "ftd_outside_ip" {
  default = []
}
variable "outside_subnet_id" {
  default = []
}
variable "inside_subnet_id" {
  default = []
}