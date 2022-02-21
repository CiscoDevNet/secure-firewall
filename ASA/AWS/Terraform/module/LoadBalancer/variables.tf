variable "external_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 22
    target_type = "ip"
  }]
}

variable "internal_listener_ports" {
  default = [{
    protocol = "TCP"
    port = 22
    target_type = "ip"
  }
  ]
}

variable "create"{
  type = string
  default = "both"
}

variable "internal_health_check" {
  default = {
    protocol = "TCP"
    port     = 22
  }
}


variable "external_health_check" {
  default = {
    protocol = "TCP"
    port     = 80
  }
}

variable "vpc_id" {}

variable "asa01_inside_ip" {
  type = string
}

variable "asa02_inside_ip" {
  type = string
}

variable "asa01_outside_ip" {
  type = string
}

variable "asa02_outside_ip" {
  type = string
}

variable "outside01_subnet_id" {
  type = string
}

variable "outside02_subnet_id" {
  type = string
}

variable "inside01_subnet_id" {
  type = string
}

variable "inside02_subnet_id" {
  type = string
}