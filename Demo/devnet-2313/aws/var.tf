variable "region" {
        default = "us-east-1"
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
variable "fmc_ip" {
    default = "10.1.0.100"
}
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
variable "prefix" {
  default = "C15C0"
}
variable "FTD_version" {
    default = "ftdv-7.4.2"
}
variable "FMC_version" {
    default = "fmcv-7.4.2"
}

variable "keyname" {
  default = "ciscoKey"
}

variable "ftd_size" {
  default = "c5.4xlarge"
}
variable "fmc_nat_id" {
  default = ""
}

variable "admin_password" {
  type = string
  default = "Cisco@123"
}

variable "fmc_hostname" {
  type = string
  default = "FMC-01"
}

variable "reg_key" {
  type = string
  default = "cisco"
}
variable "create_fmc" {
  default = true
}


################################################################################################
# For inside VM setup
################################################################################################
variable "tags" {
  type    = map(any)
  default = {}
}

################################################################################################
# For FMC Config
################################################################################################
variable "fmc_username" {
    type = string
    default = "admin"
}

variable "fmc_password" {
    type = string
    default = "Admin123"
}
variable "aws_key" {
    type = string
}
variable "aws_secret_key" {
    type = string
}