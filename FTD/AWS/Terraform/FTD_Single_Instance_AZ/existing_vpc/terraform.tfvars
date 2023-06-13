// AWS Environment
aws_access_key      = ""
aws_secret_key      = ""
key_name            = ""

region              = "us-east-1"

// "Valid values for FTD_version are ftdv-7.0.5, ftdv-7.1.0, ftdv-7.2.4, ftdv-7.3.0."
FTD_version         = "ftdv-7.3.0"

vpc_name            = "CiscoFTDv-VPC"
vpc_cidr            = "10.1.0.0/16"
create_igw          = false

mgmt_subnet         = "10.1.0.0/24"
outside_subnet      = "10.1.1.0/24"
diag_subnet         = "10.1.2.0/24"
inside_subnet       = "10.1.3.0/24"

ftd01_mgmt_ip       =  "10.1.0.11"
ftd01_outside_ip    =  "10.1.1.11"
ftd01_diag_ip       =  "10.1.2.11"
ftd01_inside_ip     =  "10.1.3.11"

