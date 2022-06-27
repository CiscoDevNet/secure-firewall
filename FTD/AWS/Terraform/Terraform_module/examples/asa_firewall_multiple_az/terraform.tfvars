// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key = ""

aws_secret_key = ""

region = "ap-south-1"

############################################################
#Define New VPC in a specific Region and Avilability Zone 
#############################################################
vpc_cidr = "172.16.0.0/16"

vpc_name = "firewall-VPC"

##################################################################################
#Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ
###################################################################################

mgmt_subnet_cidr = ["172.16.1.0/24","172.16.10.0/24"]
outside_subnet_cidr = ["172.16.3.0/24","172.16.30.0/24"]
inside_subnet_cidr = ["172.16.5.0/24","172.16.50.0/24"]
diag_subnet_cidr = ["172.16.4.0/24","172.16.40.0/24"]

ftd_mgmt_ip = ["172.16.1.23","172.16.10.24"]
ftd_outside_ip = ["172.16.3.22","172.16.30.45"]
ftd_inside_ip = ["172.16.5.67","172.16.50.87"]
ftd_diag_ip = ["172.16.4.43","172.16.40.99"]
fmc_ip = "172.16.1.123"

mgmt_subnet_name = ["mgmt1","mgmt2"]
outside_subnet_name = ["outside1","outside2"]
inside_subnet_name = ["inside1","inside2"]
diag_subnet_name = ["dmz1","dmz2"]

FTD_version = "ftdv-7.1.0"
FMC_version = "fmcv-7.1.0"
keyname = "key"
ftd_size = "c5.xlarge"





