#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "admin_password" {
    default = "Admin123"
}
variable "region" {
        default = "us-east-1"
}

variable "FTD_version" {
    default = "ftdv-7.3.0"
    validation {
        condition     = contains(["ftdv-7.0.5", "ftdv-7.1.0", "ftdv-7.2.4","ftdv-7.3.0"], var.FTD_version)
        error_message = "Valid values for var: FTD_version are (ftdv-7.0.5, ftdv-7.1.0, ftdv-7.2.4, ftdv-7.3.0)."
    } 
} 
variable "existing_vpc" {
    type    = bool
    default = false
}

variable "create_igw" {
    type    = bool
    default = true
}

variable "vpc_name" {
    default = "Cisco-FTDv-VPC"
}

//Including the Avilability Zone
variable "aws_az" {
    default = "us-east-1a"
}

//defining the VPC CIDR
variable "vpc_cidr" {
    default = "10.1.0.0/16"
}

// defining the subnets variables with the default value for Three Tier Architecure. 

variable "mgmt_subnet" {
    default = "10.1.0.0/24"
}

variable "ftd01_mgmt_ip" {
    default = "10.1.0.11"
}

variable "ftd01_outside_ip" {
    default = "10.1.1.11"
}

variable "ftd01_inside_ip" {
    default = "10.1.3.11"
}
        
variable "ftd01_diag_ip" {
    default = "10.1.2.11"
}        

variable "ftd01_dmz_ip" {
    default = "10.1.4.11"
}

variable "diag_subnet" {
    default = "10.1.2.0/24"
}

variable "outside_subnet" {
    default = "10.1.1.0/24"
}

variable "dmz_subnet" {
    default = "10.0.4.0/24"
}

variable "inside_subnet" {
    default = "10.1.3.0/24"
}

variable "size" {
  default = "c5.4xlarge"
}

