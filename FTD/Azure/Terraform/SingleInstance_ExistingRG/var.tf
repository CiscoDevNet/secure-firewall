variable "location" {
  type    = string
  default = "centraleurope"
}
variable "prefix" {
  type    = string
  default = "cisco-ftdv"
}
variable "source-address" {
  type    = string
  default = "*"
}
variable "Version" {
  default = "700.94.0"
  type    = string
}
variable "VMSize" {
  default = "Standard_D3_v2"
  type    = string
}
variable "rg_name" {
  type    = string
}
variable "vn_name" {
  type = string
}
variable "management_subnet" {
  type = string
}
variable "diagnostic_subnet" {
  type = string
}
variable "outside_subnet" {
  type = string
}
variable "inside_subnet" {
  type = string
}
variable "instancename" {
  default = "FTD01"
  type    = string
}
variable "username" {
  default = ""
  type = string
}
variable "password" {
  default = ""
  sensitive = true
  type = string
}
