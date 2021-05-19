variable "location" {
  type    = string
  default = "westeurope"
}
variable "prefix" {
  type    = string
  default = "cisco-ASAv"
}
variable "source-address" {
  type    = string
  default = "*"
}
variable "IPAddressPrefix" {
  default = "10.10"
}
variable "Version" {
  default = "915.1.1"
}
variable "VMSize" {
  default = "Standard_D3_v2"
}
variable "RGName" {
  default = "cisco-ASAv-RG"
}
variable "instancename" {
  default = "ASA"
}
variable "username" {
  default = "cisco"
}
variable "password" {
  default = "P@$$w0rd1234"
  sensitive = true
}
variable "instances" {
  default = 2
}