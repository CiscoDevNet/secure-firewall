// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key = ""

aws_secret_key = ""

region = "ap-south-1"

##################################################################################
# usecase:
# - Existing Spoke VPC
# - FMC Present in Service VPC
###################################################################################

service_vpc_name   = "test"
service_create_igw = false
service_igw_name   = "test"

mgmt_subnet_cidr    = ["172.16.220.0/24", "172.16.210.0/24"]
outside_subnet_cidr = ["172.16.230.0/24", "172.16.241.0/24"]
inside_subnet_cidr  = ["172.16.29.0/24", "172.16.190.0/24"]
diag_subnet_cidr    = ["172.16.24.0/24", "172.16.240.0/24"]
ngw_subnet_cidr     = ["172.16.211.0/24", "172.16.221.0/24"]
gwlbe_subnet_cidr   = ["172.16.212.0/24", "172.16.232.0/24"]
tgw_subnet_cidr     = ["172.16.215.0/24", "172.16.225.0/24"]

ftd_inside_gw = ["172.16.29.1", "172.16.190.1"]

lambda_subnet_cidr = "172.16.252.0/24"

fmc_ip = ""

outside_subnet_name = ["outside1", "outside2"]
mgmt_subnet_name    = ["mgmt1", "mgmt2"]
diag_subnet_name    = ["diag1", "diag2"]
gwlbe_subnet_name   = ["gwlb1", "gwlb2"]
ngw_subnet_name     = ["ngw1", "ngw2"]
tgw_subnet_name     = ["tgw1", "tgw2"]
inside_subnet_name  = ["inside1", "inside2"]

spoke_vpc_name    = "spoke-vpc"
spoke_vpc_cidr    = "10.6.0.0/16"
spoke_create_igw  = "true"
spoke_igw_name    = "spoke-igw"
spoke_subnet_cidr    = ["10.6.1.0/24", "10.6.2.0/24"]
spoke_subnet_name = ["spoke1", "spoke2"]

keyname = "lx1"

instances_per_az        = 1
availability_zone_count = 2

gwlb_name = "GWLB-test"

outside_interface_sg = [
  {
    from_port   = 6081
    protocol    = "UDP"
    to_port     = 6081
    cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
    description = "GENEVE Access"
  },
  {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
    description = "SSH Access"
  }
]

inside_interface_sg = [
  {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["172.16.29.0/24", "172.16.190.0/24"]
    description = "HTTP Access"
  }
]

mgmt_interface_sg = [
  {
    from_port   = 8305
    protocol    = "TCP"
    to_port     = 8305
    cidr_blocks = ["172.16.220.0/24", "172.16.210.0/24", "172.16.0.0/24"]
    description = "Mgmt Traffic from FMC"
  }
]

fmc_username = "admin"

fmc_password = "Cisco@123"

fmc_nat_id = "cisco"

domainUUID = "e276abec-e0f2-11e3-8169-6d9ed49b625f"