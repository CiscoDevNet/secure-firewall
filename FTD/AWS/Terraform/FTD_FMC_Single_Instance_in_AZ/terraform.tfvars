// AWS Environment -- Remove the # to before configure a value to it. 
// If you dont provide any value, it will take the default value 

############################################################
#AWS Creditials to access the AWS Cloud
#############################################################
aws_access_key      = "AKIAV2HIGYPVSIHVXXSL"

aws_secret_key      = "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"

############################################################
#Define New VPC in a specific Region and Avilability Zone 
#############################################################
vpc_name            = "FTD-Service-VPC"

region              = "ap-south-1"

aws_az              = "ap-south-1a"

FTD_version         = "ftdv-6.6.0"
//Allowed Values = ftdv-6.7.0, ftdv-6.6.0. 

FMC_version         = "fmcv-6.7.0"
//Allowed Values = fmcv-6.7.0, fmcv-6.6.0. 

##################################################################################
#Define CIDR, five Subnets. Two for managment and three for Inside, Outisde and DMZ 
###################################################################################
vpc_cidr           =  "172.16.0.0/16"

mgmt_subnet        =  "172.16.0.0/24"

diag_subnet       =  "172.16.1.0/24"

outside_subnet     =  "172.16.2.0/24"

inside_subnet      =  "172.16.3.0/24"

dmz_subnet         =  "172.16.4.0/24"

key_name             = "NGFW-KP"  
# Generate the key if you want to login thru the certifcation key

###########################################################################################
#Define the Instance size for FTD and FMC and attache the interfaces and Day0 Configuration
###########################################################################################
//FTD Interfaces IP address Configurations 
//Download the ftd_startup_file and fmc_startup_file to define the hostname, passowrd and managger  Configurations 

#Remove the # before using it

ftd_size            =  "c5.4xlarge"

//Please refer NGFWv datasheet for the supported size 
//https://www.cisco.com/c/en/us/products/collateral/security/firepower-ngfw-virtual/datasheet-c78-742858.html

fmc_size            =   "c5.4xlarge"
//Please refer FMCv datasheet for the supported size 
//https://www.cisco.com/c/en/us/products/collateral/security/firesight-management-center/datasheet-c78-736775.html

ftd01_mgmt_ip       =  "172.16.0.10" 
//FTD and FMC mgmt should be in the same subnet

fmc_mgmt_ip        =   "172.16.0.50"
//FTD and FMC mgmt should be in the same subnet

ftd01_outside_ip    =   "172.16.2.10"
 
ftd01_inside_ip     =  "172.16.3.10"

ftd01_dmz_ip        =  "172.16.4.10"

#To configured the optional nat id while adding the manager
fmc_nat_id          =  ""
