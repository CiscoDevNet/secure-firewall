// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 


############################################################
Enter your pod number below. Important you use the correct 
number otherwise you will try to overwrite someone else's
lab!
############################################################


pod_prefix = "pod-X"



#############################################################
#AWS Creditials to access the AWS Cloud
#############################################################

aws_access_key = ""

aws_secret_key = ""

region = "us-east-1"

########################################################################################
# usecase:
# - Centralized Architecture with Gateway Load balancer and 2 Cisco FTD as its targets.
# - FMC Present in Service VPC
########################################################################################

service_vpc_name   = "Security-VPC"
service_create_igw = true
service_igw_name   = "FMCv Internet Gateway"
service_vpc_cidr = "172.16.0.0/16"
mgmt_subnet_cidr    = ["172.16.1.0/24", "172.16.10.0/24"]
outside_subnet_cidr = ["172.16.2.0/24", "172.16.20.0/24"]
inside_subnet_cidr  = ["172.16.3.0/24", "172.16.30.0/24"]
diag_subnet_cidr    = ["172.16.4.0/24", "172.16.40.0/24"]
ngw_subnet_cidr     = ["172.16.5.0/24", "172.16.50.0/24"]
gwlbe_subnet_cidr   = ["172.16.6.0/24", "172.16.60.0/24"]
tgw_subnet_cidr     = ["172.16.7.0/24", "172.16.70.0/24"]

ftd_inside_gw       = ["172.16.3.1", "172.16.30.1"]

fmc_ip              = "172.16.1.151"

outside_subnet_name = ["outside1", "outside2"]
mgmt_subnet_name    = ["mgmt1", "mgmt2"]
diag_subnet_name    = ["diag1", "diag2"]
gwlbe_subnet_name   = ["gwlb1", "gwlb2"]
ngw_subnet_name     = ["ngw1", "ngw2"]
tgw_subnet_name     = ["tgw1", "tgw2"]
inside_subnet_name  = ["inside1", "inside2"]

a_vpc_cidr      = "10.1.0.0/16"
a_vpc_name      = "App-VPC-A"
a_create_igw    = false
a_subnet_cidr   = ["10.1.1.0/24"]
a_subnet_name   = ["App-A-subnet"]

b_vpc_cidr      = "10.2.0.0/16"
b_vpc_name      = "App-VPC-B"
b_create_igw    = false
b_subnet_cidr   = ["10.2.2.0/24"]
b_subnet_name   = ["App-B-subnet"]

c_vpc_cidr      = "172.17.0.0/16"
c_vpc_name      = "3rd party VPC"
c_create_igw    = false
c_subnet_cidr   = ["172.17.1.0/24"]
c_subnet_name   = ["Third-Party-VPC"]

keyname = "gwlb-adv-key"

instances_per_az        = 1
availability_zone_count = 2

gwlb_name = "GWLB"

outside_interface_sg = [
  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "mgmt-sg"
  }
]

inside_interface_sg = [
  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "mgmt-sg"
  }
]

mgmt_interface_sg = [
  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "mgmt-sg"
  }
]

fmc_mgmt_interface_sg = [
  {
   from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "mgmt-sg"
  },
  {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "mgmt-sg"
  }
]

fmc_username = "admin"
fmc_password = "Cisco@123"
create_fmc = true
tgw_appliance_mode = "enable" //"disable"


cdo_token = ""
