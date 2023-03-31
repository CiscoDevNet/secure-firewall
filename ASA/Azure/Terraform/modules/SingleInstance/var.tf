variable "location" {
  type    = string
  default = "westeurope"
}
variable "prefix" {
  type    = string
  default = "cisco-asav"
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
  default = "cisco-asav-RG"
}
variable "instancename" {
  default = "cisco-asav"
}
variable "instanceusername" {
  default = "cisco"
}
variable "instancepassword" {
  default = "Pa$$w0rd1234"
}
variable "day-0-config" {
  default = "ASA_Running_Config.txt"
}