variable "location" {
  type    = string
  default = "westeurope"
}
variable "prefix" {
  type    = string
  default = "cisco-ftdv"
}
variable "source-address" {
  type    = string
  default = "*"
}
variable "IPAddressPrefix" {
  default = "10.10"
}
variable "Version" {
  default = "67065.0.0"
}
variable "VMSize" {
  default = "Standard_D3_v2"
}
variable "RGName" {
  default = "cisco-ftdv-RG"
}
variable "instancename" {
  default = "FTD01"
}
variable "username" {
  default = "cisco"
}
variable "password" {
  default = "P@$$w0rd1234"
  sensitive = true
}
