// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key      = ""

aws_secret_key      = ""

############################################################
#Define New VPC in a specific Region and Avilability Zone 
#############################################################
vpc_name            = "FTD-Service-VPC"

region              = "us-east-1"

FTD_version         = "ftdv-7.3.0" 

FMC_version         = "fmcv-7.3.0"

##################################################################################
#Define CIDR, four Subnets. One managment and three for Inside, Outisde and DMZ 
###################################################################################
vpc_cidr           =  "172.16.0.0/16"

mgmt_subnet        =  "172.16.0.0/24"

outside_subnet     =  "172.16.2.0/24"

inside_subnet      =  "172.16.3.0/24"

dmz_subnet         =  "172.16.4.0/24"

###########################################################################################
#Define the Instance size for FTD and FMC and attach the interfaces and Day0 Configuration
###########################################################################################
//Download the ftd_startup_file and fmc_startup_file to define the hostname, passowrd and managger  Configurations 

#Remove the # before using it

ftd_size            =  "c5.4xlarge"

//Please refer NGFWv datasheet for the supported size 
//https://www.cisco.com/c/en/us/products/collateral/security/firepower-ngfw-virtual/datasheet-c78-742858.html

fmc_size            =   "c5.4xlarge"
//Please refer FMCv datasheet for the supported size 
//https://www.cisco.com/c/en/us/products/collateral/security/firesight-management-center/datasheet-c78-736775.html

################################################################
#First FTD Instance Configurations.
################################################################
 
ftd01_mgmt_ip       =  "172.16.0.10" 
//FTD and FMC mgmt should be in the same subnet

fmc_mgmt_ip        =   "172.16.0.50"
//FTD and FMC mgmt should be in the same subnet

ftd01_outside_ip    =   "172.16.2.10"
 
ftd01_inside_ip     =  "172.16.3.10"

ftd01_dmz_ip        =  "172.16.4.10"
 
################################################################
#Second FTD Instance Configurations.
################################################################

ftd02_mgmt_ip       =  "172.16.0.20" 
//FTD and FMC mgmt should be in the same subnet

ftd02_outside_ip    =   "172.16.2.20"
 
ftd02_inside_ip     =  "172.16.3.20"

ftd02_dmz_ip        =  "172.16.4.20"

#To configured the optional nat id while adding the manager
fmc_nat_id          =  ""


listener_ports      =  {
    80  =   "TCP"
    22  =   "TCP"
    443 =   "TCP"
}