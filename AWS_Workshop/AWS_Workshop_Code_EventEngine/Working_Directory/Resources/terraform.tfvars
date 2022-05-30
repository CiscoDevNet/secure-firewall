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
vpc_name = "IAC-VPC"
vpc_cidr = ""
create_igw = false
# Generate the key if you want to login thru the  key
keyname = "lx1"
instances_per_az        = 1
availability_zone_count = 2

##################################################################################
#Define CIDR, Subnets for managment and three for Inside, Outisde and Diag
###################################################################################

mgmt_subnet_cidr = ["10.0.1.0/24","10.0.10.0/24"]
outside_subnet_cidr = ["10.0.2.0/24","10.0.20.0/24"]
inside_subnet_cidr = ["10.0.3.0/24","10.0.30.0/24"]
diag_subnet_cidr = ["10.0.4.0/24","10.0.40.0/24"]
app_subnet_cidr = ["10.0.5.0/24","10.0.50.0/24"]
bastion_subnet_cidr = "10.0.6.0/24"

ftd_mgmt_ip = ["10.0.1.10","10.0.10.10"]
ftd_outside_ip = ["10.0.2.10","10.0.20.10"]
ftd_inside_ip = ["10.0.3.10","10.0.30.10"]
ftd_diag_ip = ["10.0.4.10","10.0.40.10"]
ftd_app_ip = ["10.0.5.10","10.0.50.10"]
bastion_ip = "10.0.6.10"
fmc_ip = "10.0.1.50"

inside_subnet_name = ["inside1","inside2"]
outside_subnet_name = ["outside1","outside2"]
mgmt_subnet_name = ["mgmt1","mgmt2"]
diag_subnet_name = ["diag1","diag2"]
app_subnet_name = ["app1","app2"]
bastion_subnet_name = "bastion"

create = "external"

outside_interface_sg = [
    {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["10.0.2.0/24","10.0.20.0/24"]
    },
    {
        from_port = 22
        protocol = "TCP"
        to_port = 22
        cidr_blocks = ["10.0.2.0/24","10.0.20.0/24"]
    }
]

inside_interface_sg = [
    {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["10.0.5.10/32","10.0.50.10/32"]
    }
]

mgmt_interface_sg = [
    {
        from_port = 8305
        protocol = "TCP"
        to_port = 8305
        cidr_blocks = ["10.0.1.50/32"]
    }
]

fmc_mgmt_interface_sg = [
    {
        from_port = 443
        protocol = "TCP"
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        from_port = 8305
        protocol = "TCP"
        to_port = 8305
        cidr_blocks = ["10.0.1.10/32","10.0.10.10/32"]
    }
]

bastion_interface_sg = [
    {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["10.0.5.10/32","10.0.50.10/32"]
    },
    {
        from_port = 22
        protocol = "TCP"
        to_port = 22
        cidr_blocks = ["10.0.5.10/32","10.0.50.10/32"]
    }
]

app_interface_sg = [
    {
        from_port = 80
        protocol = "TCP"
        to_port = 80
        cidr_blocks = ["10.0.5.100/32","10.0.50.100/32"]
    },
    {
        from_port = 22
        protocol = "TCP"
        to_port = 22
        cidr_blocks = ["10.0.5.100/32","10.0.50.100/32"]
    }
]