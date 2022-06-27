variable "aws_access_key" {} 
variable "aws_secret_key" {}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = null
}

variable "vpc_name" {
  type    = string
  default = null
}

variable "create_igw" {
  type    = string
  default = true
}

variable "availability_zone_count" {
  description = "Spacified availablity zone count . "
  type    = number
  default = 2
}

variable "instances_per_az" {
  description = "Spacified no. of instance per az wants to be create . "
  type    = number
  default = 1
}

variable "mgmt_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_mgmt_ip" {
  default = []
}

variable "outside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_outside_ip" {
  default = []
}

variable "diag_subnet_cidr" {
  description = "List out diagonastic Subnet CIDR . "
  type    = list(string)
  default = []
}

variable "ftd_diag_ip" {
  description = "List out FTD Diagonostic IPs . "
  default = []
}

variable "inside_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "ftd_inside_ip" {
  default = []
}

variable "fmc_ip" {
  description = "List out FMCv IPs . "
  type = string
  default = ""
}

variable "mgmt_subnet_name" {
  type    = list(string)
  default = []
}

variable "outside_subnet_name" {
  type    = list(string)
  default = []
}

variable "inside_subnet_name" {
  type    = list(string)
  default = []
}

variable "diag_subnet_name" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "fmc_mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type = bool
  default = false
}

variable "use_fmc_eip" {
  description = "boolean value to use EIP on FMC or not"
  type = bool
  default = false
}

variable "mgmt_interface_id" {
  type    = list(string)
  default = []
}

variable "outside_interface_id" {
  type    = list(string)
  default = []
}

variable "inside_interface_id" {
  type    = list(string)
  default = []
}

variable "diag_interface_id" {
  type    = list(string)
  default = []
}

variable "fmc_interface_id" {
  description = "Spacified FMCv interface . "
  type    = string
  default = ""
}

variable "FTD_version" {
  description = "specified FTD version."
  type = string
  default = "ftdv-7.1.0"
}

variable "FMC_version" {
  description = "specified FMC version."
  type = string
  default = "fmcv-7.1.0"
}

variable "keyname" {
  description = "specified key pair name to connect firewall ."
  type = string
}

variable "ftd_size" {
  description = "specified server instance type ."
  type = string
  default = "c5.4xlarge"
}

variable "fmc_admin_password" {
  description = "spacified fmc admin password ."
  type = string
  default = "Cisco@123"
}

variable "fmc_hostname" {
  description = "spacified fmc hostname ."
  type = string
  default = "FMC-01"
}

variable "reg_key" {
  description = "spacified reg key ."
  type = string
  default = "cisco"
}

variable "create_fmc" {
  description = "Boolean value to create FMC or not"
  type = Bool
  default = true
}