// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key = ""

aws_secret_key = ""

region = "ap-south-1"

##################################################################################
#Define CIDR, Subnets for managment and three for Inside, Outisde and DMZ
###################################################################################
service_vpc_cidr = "172.16.0.0/16"
service_vpc_name = "service-vpc"
service_create_igw = true

mgmt_subnet_cidr = ["172.16.1.0/24","172.16.10.0/24"]
outside_subnet_cidr = ["172.16.3.0/24","172.16.30.0/24"]
diag_subnet_cidr = ["172.16.4.0/24","172.16.40.0/24"]
service_subnet_cidr = ["172.16.7.0/24","172.16.70.0/24"]

inside_subnet_cidr = ["172.16.9.0/24","172.16.90.0/24"]

ngw_subnet_cidr = ["172.16.11.0/24","172.16.20.0/24"]
gwlbe_subnet_cidr = ["172.16.12.0/24","172.16.22.0/24"]
tgw_subnet_cidr = ["172.16.15.0/24", "172.16.25.0/24"]

ftd_mgmt_ip = ["172.16.1.23","172.16.10.24"]
ftd_outside_ip = ["172.16.3.22","172.16.30.45"]
ftd_diag_ip = ["172.16.4.43","172.16.40.99"]
fmc_ip = "172.16.1.100"

ftd_inside_ip = ["172.16.9.23","172.16.90.24"]

outside_subnet_name = ["outside1","outside2"]
mgmt_subnet_name = ["mgmt1","mgmt2"]
diag_subnet_name = ["diag1","diag2"]


gwlbe_subnet_name  = ["gwlb1","gwlb2"]
ngw_subnet_name = ["ngw1","ngw2"]
tgw_subnet_name = ["tgw1","tgw2"]

inside_subnet_name = ["inside1","inside2"]

spoke_vpc_cidr   =  "10.0.0.0/16"
spoke_vpc_name   =  "spoke-vpc"
spoke_create_igw = "true"
spoke_subnet_cidr = ["10.0.1.0/24","10.0.2.0/24"]
spoke_subnet_name = ["spoke1","spoke2"]

keyname = "lx1"
instances_per_az        = 1
availability_zone_count = 2

aws_availability_zones = ["ap-south-1a", "ap-south-1b"]

GWLB_name      = "GWLB"






