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
vpc_cidr = "172.16.0.0/16"
vpc_name = "service-vpc"
create_igw = true

mgmt_subnet_cidr = ["172.16.1.0/24"]
outside_subnet_cidr = ["172.16.3.0/24"]
diag_subnet_cidr = ["172.16.4.0/24"]
inside_subnet_cidr = ["172.16.9.0/24"]

ftd_mgmt_ip = ["172.16.1.23"]
ftd_outside_ip = ["172.16.3.22"]
ftd_diag_ip = ["172.16.4.43"]
fmc_ip = "172.16.1.100"

ftd_inside_ip = ["172.16.9.23"]

outside_subnet_name = ["outside1","outside2"]
mgmt_subnet_name = ["mgmt1","mgmt2"]
diag_subnet_name = ["diag1","diag2"]

inside_subnet_name = ["inside1","inside2"]

keyname = "lx1"
instances_per_az        = 1
availability_zone_count = 1
create_fmc = false







