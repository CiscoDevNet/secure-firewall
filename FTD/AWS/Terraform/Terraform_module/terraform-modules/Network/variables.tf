variable "vpc_cidr" {
  description = "Specified CIDR for VPC . "
  type    = string
  default = ""
}

variable "vpc_name" {
  description = "Specified VPC Name . "
  type    = string
  default = "IAC-VPC" 
}

variable "create_igw" {
  description = " Condition to create IGW . "
  type    = bool
  default = false
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

#if subnet cidr empty then use existing based on subnet name
variable "mgmt_subnet_cidr" {
  description = "List out management Subnet CIDR . "
  type    = list(string)
  default = []
}

variable "ftd_mgmt_ip" {
  description = "List out management IPs . "
  type    = list(string)
  default = []
}

variable "outside_subnet_cidr" {
  description = "List out outside Subnet CIDR . "
  type    = list(string)
  default = []
}

variable "ftd_outside_ip" {
  description = "List outside IPs . "
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
  description = "List out inside Subnet CIDR . "
  type    = list(string)
  default = []
}

variable "ftd_inside_ip" {
  description = "List FTD inside IPs . "
  type    = list(string)
  default = []
}

variable "fmc_ip" {
  description = "List out FMCv IPs . "
  type = string
  default = ""
}

variable "mgmt_subnet_name" {
  description = "Spacified management subnet name ."
  type    = list(string)
  default = []
}

variable "outside_subnet_name" {
  description = "Spacified outside subnet name ."
  type    = list(string)
  default = []
}

variable "inside_subnet_name" {
  description = "Spacified inside subnet name ."
  type    = list(string)
  default = []
}

variable "diag_subnet_name" {
  description = "Spacified diagonstic subnet name ."
  type    = list(string)
  default = []
}

variable "tags" {
  description = "tags to map with resources ."
  type    = map(any)
  default = {}
}

variable "mgmt_interface" {
  description = "list out management interface ."
  type    = list(string)
  default = []
}

variable "outside_interface" {
  description = "list out outside interface ."
  type    = list(string)
  default = []
}

variable "inside_interface" {
  description = "list out Inside interface ."
  type    = list(string)
  default = []
}

variable "diag_interface" {
  description = "list out Diagonstic interface ."
  type    = list(string)
  default = []
}

variable "fmc_interface" {
  description = "Spacified FMCv interface . "
  type    = string
  default = ""
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