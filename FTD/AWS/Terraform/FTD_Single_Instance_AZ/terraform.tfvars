// AWS Environment
aws_access_key      = "<Enter access key name>"

aws_secret_key      = "<Enter secret key name>"

key_name            = "<Enter key name>"

vpc_name            = "Service-VPC"

region              = "us-east-1"

aws_az              = "us-east-1b"

//Allowed Values = ftdv-6.7.0, ftdv-6.6.0,
FTD_version         = "ftdv-7.3.0"

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