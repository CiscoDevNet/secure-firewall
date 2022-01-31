variable "listener_ports" {
  default = {
    22 = "TCP"
    #443 = "TCP"
  }
}

variable "health_check" {
  default = {
    protocol = "TCP"
    port     = 22
  }
}

variable "vpc_id" {}

variable "asa01_inside_ip" {}

variable "asa02_inside_ip" {}

variable "asa01_outside_ip" {}

variable "asa02_outside_ip" {}

variable "outside01_subnet_id" {}

variable "outside02_subnet_id" {}

variable "inside01_subnet_id" {}

variable "inside02_subnet_id" {}