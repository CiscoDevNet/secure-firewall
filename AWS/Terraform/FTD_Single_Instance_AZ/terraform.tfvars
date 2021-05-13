// AWS Environment
aws_access_key      = "<enter value here>"

aws_secret_key      = "<enter value here>"

key_name            = "<enter value here>"

vpc_name            = "Service-VPC"

region              = "eu-central-1"

aws_az              = "eu-central-1b"

//Allowed Values = ftdv-6.7.0, ftdv-6.6.0,
FTD_version         = "ftdv-6.7.0"

vpc_cidr            = "10.1.0.0/16"

mgmt_subnet         = "10.1.0.0/24"

outside_subnet      = "10.1.1.0/24"

diag_subnet         = "10.1.2.0/24"

inside_subnet       = "10.1.3.0/24"

dmz_subnet          = "10.1.4.0/24"


ftd01_mgmt_ip       =  "10.1.0.11"

ftd01_outside_ip    =  "10.1.1.11"

ftd01_diag_ip       =  "10.1.2.11"

ftd01_inside_ip     =  "10.1.3.11"

ftd01_dmz_ip        =  "10.1.4.11"

size                = "c5.4xlarge"
