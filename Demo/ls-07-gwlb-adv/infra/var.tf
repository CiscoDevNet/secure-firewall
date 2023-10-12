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

variable "service_create_igw" {
  type        = bool
  description = "Boolean value to decide if to create IGW or not"
  default     = false
}

variable "service_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "mgmt_subnet_cidr" {
  description = "List of management Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_mgmt_ip" {
  description = "List out management IPs . "
  type        = list(string)
  default     = []
}

variable "outside_subnet_cidr" {
  description = "List out outside Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_outside_ip" {
  type        = list(string)
  description = "List of outside IPs . "
  default     = []
}

variable "diag_subnet_cidr" {
  description = "List out diagonastic Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_diag_ip" {
  type        = list(string)
  description = "List out FTD Diagonostic IPs . "
  default     = []
}

variable "inside_subnet_cidr" {
  description = "List out inside Subnet CIDR . "
  type        = list(string)
  default     = []
}

variable "ftd_inside_ip" {
  description = "List FTD inside IPs . "
  type        = list(string)
  default     = []
}

variable "ftd_inside_gw" {
  description = "Inside subnet Gateway"
  type        = list(string)
}

variable "fmc_ip" {
  description = "List out FMCv IPs . "
  type        = string
  default     = ""
}

variable "tgw_subnet_cidr" {
  type        = list(string)
  description = "List of Transit GW Subnet CIDR"
  default     = []
}

variable "lambda_subnet_cidr" {
  type        = string
  description = "Lambda Subnet CIDR"
  default     = ""
}

variable "availability_zone_count" {
  type        = number
  description = "Spacified availablity zone count . "
  default     = 2
}

variable "mgmt_subnet_name" {
  type        = list(string)
  description = "Specified management subnet names"
  default     = []
}

variable "outside_subnet_name" {
  type        = list(string)
  description = "Specified outside subnet names"
  default     = []
}

variable "diag_subnet_name" {
  description = "Specified diagonstic subnet names"
  type        = list(string)
  default     = []
}

variable "inside_subnet_name" {
  type        = list(string)
  description = "Specified inside subnet names"
  default     = []
}

variable "tgw_subnet_name" {
  type        = list(string)
  description = "List of name for TGW Subnets"
  default     = []
}

variable "lambda_subnet_name" {
  type        = string
  description = "Name for Lambda Subnet"
  default     = ""
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

variable "fmc_mgmt_interface_sg" {
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
  description = "Spacified no. of instance per az wants to be create . "
  default     = 1
}

########################################################################
## Spoke  
########################################################################

variable "a_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = null
}

variable "a_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = null
}

variable "a_create_igw" {
  type        = bool
  description = "Condition to create IGW . "
  default     = true
}

variable "a_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "a_subnet_cidr" {
  type        = list(string)
  description = "List out a Subnet CIDR . "
  default     = []
}

variable "a_subnet_name" {
  type        = list(string)
  description = "List out a Subnet names . "
  default     = []
}

variable "b_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = null
}

variable "b_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = null
}

variable "b_create_igw" {
  type        = bool
  description = "Condition to create IGW . "
  default     = true
}

variable "b_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "b_subnet_cidr" {
  type        = list(string)
  description = "List out a Subnet CIDR . "
  default     = []
}

variable "b_subnet_name" {
  type        = list(string)
  description = "List out a Subnet names . "
  default     = []
}

variable "c_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = null
}

variable "c_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = null
}

variable "c_create_igw" {
  type        = bool
  description = "Condition to create IGW . "
  default     = true
}

variable "c_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "c_subnet_cidr" {
  type        = list(string)
  description = "List out a Subnet CIDR . "
  default     = []
}

variable "c_subnet_name" {
  type        = list(string)
  description = "List out a Subnet names . "
  default     = []
}

variable "gwlbe_subnet_cidr" {
  type        = list(string)
  description = "List out GWLBE Subnet CIDR . "
  default     = []
}

variable "gwlbe_subnet_name" {
  type        = list(string)
  description = "List out GWLBE Subnet names . "
  default     = []
}

variable "ngw_subnet_cidr" {
  type        = list(string)
  description = "List out NGW Subnet CIDR . "
  default     = []
}

variable "ngw_subnet_name" {
  type        = list(string)
  description = "List out NGW Subnet names . "
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

variable "transit_gateway_name" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = "tgw"
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = false
}

variable "ftd_version" {
  default     = "ftdv-7.3.0"
  description = "Version of the FTD to be deployed"
}

variable "lambda_func_name" {
  type        = string
  description = "Name of the lambda function used"
  default     = "lambda_config_func"
}

variable "fmc_username" {
  type        = string
  description = "FMC Username for API access"
}

variable "fmc_password" {
  type        = string
  description = "FMC User Password for API access"
}

variable "create_tgw" {
  type        = bool
  description = "Boolean value to decide if transit gateway needs to be created"
  default     = true
}

variable "create_fmc" {
  type        = bool
  description = "Boolean value to decide if Cisco FMC needs to be created"
  default     = false
}

variable "tgw_appliance_mode"{
  type = string
  default = "enable"
}

variable "pod_prefix"{
  type = string
}

variable "cdo_token"{
  type = string
  default = null
}
