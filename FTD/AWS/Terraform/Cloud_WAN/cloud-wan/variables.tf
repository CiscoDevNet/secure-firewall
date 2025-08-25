variable "prefix" {
  description = "Prefix added to the resources created"
  type        = string
  default     = ""
}

variable "aws_access_key" {
  type        = string
  description = "AWS ACCESS KEY"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS SECRET KEY"
}
variable "region" {
  type        = string
  description = "AWS REGION"
  default     = "us-east-1"
}

variable "service_vpc_cidr" {
  type        = string
  description = "Service VPC CIDR"
  default     = null
}

variable "service_vpc_name" {
  type        = string
  description = "Service VPC Name"
  default     = null
}

variable "wan_subnet_cidr" {
  type        = list(string)
  description = "List of Cloud WAN GW Subnet CIDR"
  default     = []
}

variable "availability_zone_count" {
  type        = number
  description = "Specify availablity zone count. "
  default     = 2
}

variable "wan_subnet_name" {
  type        = list(string)
  description = "List of name for wan Subnets"
  default     = []
}

variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outside Interface SG"
  }]
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Inside Interface SG"
  }]
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Mgmt Interface SG"
  }]
}

variable "instances_per_az" {
  type        = number
  description = "Specify no. of instance per az needed. "
  default     = 1
}


variable "gwlbe_subnet_cidr" {
  type        = list(string)
  description = "List out GWLBE Subnet CIDR. "
  default     = []
}

variable "gwlbe_subnet_name" {
  type        = list(string)
  description = "List out GWLBE Subnet names. "
  default     = []
}

variable "ngw_subnet_cidr" {
  type        = list(string)
  description = "List out NGW Subnet CIDR. "
  default     = []
}

variable "ngw_subnet_name" {
  type        = list(string)
  description = "List out NGW Subnet names. "
  default     = []
}

########################################################################
## Instances
########################################################################

variable "ftd_size" {
  type        = string
  description = "FTD Instance Size"
  default     = "c5.xlarge"
}

variable "keyname" {
  type        = string
  description = "key to be used for the instances"
}

########################################################################
## GatewayLoadbalncer 
########################################################################

variable "gwlb_name" {
  type        = string
  description = "name for Gateway loadbalancer"
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = false
}

variable "ftd_version" {
  default = "ftdv-7.6.0-41"
}

variable "reg_key" {
  type        = string
  description = "FTD registration key"
}

variable "fmc_nat_id" {
  type        = string
  description = "FMC Registration NAT ID"
  default     = "cisco"
}

variable "ftd_admin_password" {
  description = "Specify ftd admin password."
  type        = string
  sensitive   = true
  default     = ""
}

variable "fmc_mgmt_ip" {
  description = "IP of you FMC"
  type        = string
}

variable "fmc_username" {
  type        = string
  description = "FMC username"
  default     = "admin"
}

variable "fmc_password" {
  type        = string
  description = "FMC admin password"
}

variable "fmc_insecure_skip_verify" {
  type        = bool
  description = "Condition to verify FMC certificate"
  default     = true
}

variable "ftd_inside_gw" {
  description = "Inside subnet Gateway"
  type        = list(string)
  default     = ["10.0.11.1", "10.0.12.1"]
}

variable "ftd_outside_gw" {
  description = "Outside subnet Gateway"
  type        = list(string)
  default     = ["10.0.21.1", "10.0.22.1"]
}

variable "performance_tier" {
  type        = string
  description = "FTDv Performance Tier"
  default     = ""
}

variable "byol" {
  type        = bool
  description = "If true, deploys FTDv with Bring Your Own License Image. If false, deploys FTDv with Pay As You Go Image."
  default     = true
}