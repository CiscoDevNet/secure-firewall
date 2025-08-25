// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key = ""

aws_secret_key = ""

region = "us-east-1"

##################################################################################
#Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ
###################################################################################
service_vpc_cidr        = "10.0.0.0/16" // Keep /16
service_vpc_name        = "service-vpc"
keyname                 = "EnterYourExistingKeyname"
instances_per_az        = 1
availability_zone_count = 2
prefix                  = "C15C0"
use_ftd_eip             = true
gwlb_name               = "GWLB"
reg_key                 = "cisco"
ftd_admin_password      = "EnterFtdPassword"
fmc_mgmt_ip             = "X.X.X.X"
fmc_username            = "admin"
fmc_password            = "EnterFmcPassword"
ftd_version             = "ftdv-7.6.0-113" // FTDv 7.6+
ftd_size                = "c5.xlarge"
performance_tier        = ""
byol                    = true