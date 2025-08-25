// AWS Environment
aws_access_key = ""
aws_secret_key = ""

// Enter the region assigned as per you pod number
region = "us-east-1"

pod_number = 0 // Enter you pod number ex: "10"

// "Valid values for FTD_version are ftdv-7.0.5, ftdv-7.1.0, ftdv-7.2.4, ftdv-7.3.0."
FTD_version = "ftdv-7.3.0"

// "Valid values for vpc_name are CiscoFTDv-VPC1,
// CiscoFTDv-VPC2, CiscoFTDv-VPC3, CiscoFTDv-VPC4,
// and so on.."
// Enter the VPC assigned to your pod number
vpc_name = ""
vpc_cidr = "10.1.0.0/16"

mgmt_subnet    = "10.1.0.0/24"
outside_subnet = "10.1.1.0/24"
diag_subnet    = "10.1.2.0/24"
inside_subnet  = "10.1.3.0/24"

ftd01_mgmt_ip    = "10.1.0."
ftd01_outside_ip = "10.1.1."
ftd01_diag_ip    = "10.1.2."
ftd01_inside_ip  = "10.1.3."

create_igw   = false
existing_vpc = true
